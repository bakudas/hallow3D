extends RigidBody
class_name Player

export(int, 5, 10) var speed : int = 7
var _motion : Vector3 = Vector3.ZERO
var _direction : float = 1 setget set_direction, get_direction
var _attack : bool = false setget set_attack, get_attack
var _anim_prev : String
var _anim_cur : String setget set_current_animation, get_current_animation

var fx_hit : PackedScene = preload("res://entities/fx_hit.tscn")

func _physics_process(delta) -> void:
	_controls()
	_animations()
	set_linear_velocity(get_motion())
	
	print($sprite.get_rotation_degrees())


##
## handling with inputs and controls
# warning-ignore:unused_argument
func _controls() -> void:
	var left : bool = Input.is_action_pressed("ui_left")
	var right : bool = Input.is_action_pressed("ui_right")
	var up : bool = Input.is_action_pressed("ui_up")
	var down : bool = Input.is_action_pressed("ui_down")
	var atk : bool = Input.is_action_just_pressed("ui_select")
	
	if left and !get_attack():
		paper_rotation()
		set_motion(speed, 0, 0)
		set_direction(-1)
	elif right and !get_attack():
		paper_rotation()
		set_motion(-speed, 0, 0)
		set_direction(1)
	else:
		set_motion(0, get_motion().y , get_motion().z)
		
	if up and !get_attack():
		set_motion(0, 0, speed)
	elif down and !get_attack():
		set_motion(0, 0, -speed)
	else:
		set_motion(get_motion().x, get_motion().y, 0)
		
	if atk:
		paper_rotation()
		set_attack(true)


func paper_rotation() -> void:
	$Tween.remove_all()
	$Tween.interpolate_property($sprite,"rotation_degrees:y", 0, 180, .4, Tween.TRANS_LINEAR)
	$Tween.start()
	yield($Tween, "tween_completed")



##
## handling with animations
func _animations() -> void:
	
	if get_motion() == Vector3.ZERO and !get_attack():
		set_current_animation("idle")
	elif get_motion() != Vector3.ZERO and !get_attack():
		set_current_animation("run")
	else:
		set_current_animation("atk")


func set_current_animation(anim:String):
	_anim_prev = get_current_animation()
	_anim_cur = anim
	$anim.play(_anim_cur)


func get_current_animation() -> String:
	_anim_cur = $anim.get_current_animation()
	return _anim_cur


##
## motion setter and getter
func set_motion(x:float, y:float, z:float) -> void:
	_motion.x = x
	_motion.y = y
	_motion.z = z


func get_motion() -> Vector3:
	return _motion


##
## attack setter and getter
func set_attack(state:bool) -> void:
	_attack = state
	if _attack:
		$trigger_attack.set_monitoring(true)
	else:
		$trigger_attack.set_monitoring(false)


func get_attack() -> bool:
	return _attack


##
## direction setter and getter
func set_direction(var dir:float) -> void:
	_direction = dir
	$sprite.scale.x = _direction


func get_direction() -> float:
	return _direction


func _on_trigger_attack_body_entered(body):
	if body.is_in_group("inimigos"):
		cast_fx_hit(body)
		body.queue_free()


func cast_fx_hit(body) -> void:
	var fx_hit_valendo = fx_hit.instance() #instanciando a parada
	get_parent().add_child(fx_hit_valendo) #pegando a raiz e adicionando o child
	fx_hit_valendo.translation = body.translation #setando x,y,z ao fx
