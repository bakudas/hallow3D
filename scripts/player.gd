extends RigidBody


export(int, 5, 10) var speed : int = 7
var _motion : Vector3 = Vector3.ZERO
var _direction : int = 1 setget set_direction, get_direction
var _attack : bool = false setget set_attack, get_attack
var anim_prev : String
var anim_cur : String setget set_current_animation, get_current_animation


func _physics_process(delta) -> void:
	$sprite.scale.x = get_direction()
	_controls(delta)
	set_linear_velocity(get_motion())
	_animations()


##
## handling with inputs and controls
func _controls(delta) -> void:
	var left : bool = Input.is_action_pressed("ui_left")
	var right : bool = Input.is_action_pressed("ui_right")
	var up : bool = Input.is_action_pressed("ui_up")
	var down : bool = Input.is_action_pressed("ui_down")
	var atk : bool = Input.is_action_just_pressed("ui_select")
	
	if left and !get_attack():
		set_motion(speed, 0, 0)
		set_direction(1)
	elif right and !get_attack():
		set_motion(-speed, 0, 0)
		set_direction(-1)
	else:
		set_motion(0, get_motion().y , get_motion().z)
		
	if up and !get_attack():
		set_motion(0, 0, speed)
	elif down and !get_attack():
		set_motion(0, 0, -speed)
	else:
		set_motion(get_motion().x, get_motion().y, 0)
		
	if atk:
		set_attack(true)


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
	anim_prev = get_current_animation()
	anim_cur = anim
	$anim.play(anim_cur)


func get_current_animation() -> String:
	anim_cur = $anim.get_current_animation()
	return anim_cur


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


func get_attack() -> bool:
	return _attack


##
## direction setter and getter
func set_direction(var dir:int) -> void:
	_direction = dir


func get_direction() -> int:
	return _direction

