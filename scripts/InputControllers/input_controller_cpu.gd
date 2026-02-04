class_name InputControllerCpu extends InputController

const POSSIBLE_DIRECTIONS = [
	Vector2.UP,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.RIGHT
]

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	match controller_type:
		ControllerType.COMPUTER_EASY:   _ai_loop_easy()
		ControllerType.COMPUTER_MEDIUM: _ai_loop_medium()
		ControllerType.COMPUTER_HARD:   _ai_loop_hard()

func _ai_loop_easy() -> void:
	direction = POSSIBLE_DIRECTIONS.pick_random()

	await get_tree().create_timer(1.0).timeout
	shoot.emit()
	await get_tree().create_timer(1.0).timeout
	shoot.emit()
	await get_tree().create_timer(1.0).timeout
	
	_ai_loop_easy()
	
func _ai_loop_medium() -> void:
	var direction_choices : Array[Vector2] = []
	
	direction_choices.append_array(POSSIBLE_DIRECTIONS)
	direction_choices.append(_get_direction_to_target_tank(Tank.TankType.PLAYER_1))
	direction_choices.append(_get_direction_to_target_tank(Tank.TankType.PLAYER_2))
	
	direction = direction_choices.pick_random()

	await get_tree().create_timer(1.0).timeout
	shoot.emit()
	await get_tree().create_timer(0.5).timeout
	shoot.emit()
	await get_tree().create_timer(0.5).timeout
	shoot.emit()
	await get_tree().create_timer(1.0).timeout

	_ai_loop_medium()
	
func _ai_loop_hard() -> void:
	direction = _get_closest_4way_direction(Global.computer_target.position)
	
	await get_tree().create_timer(0.25).timeout
	shoot.emit()
	await get_tree().create_timer(0.25).timeout
	shoot.emit()
	await get_tree().create_timer(0.50).timeout
	
	direction = POSSIBLE_DIRECTIONS.pick_random()

	await get_tree().create_timer(0.25).timeout
	shoot.emit()
	await get_tree().create_timer(0.25).timeout
	shoot.emit()

	_ai_loop_hard()

func _get_direction_to_target_tank(tank_type: Tank.TankType) -> Vector2:
	var this_tank : Tank = get_parent()
	
	var target = Global.computer_target.position

	for tank in Global.tanks.get_children() as Array[Tank]:
		if tank.type == tank_type:
			target = tank.position
			
	var exact_direction = this_tank.position.direction_to(target)
	
	return _get_closest_4way_direction(exact_direction)
	
func _get_closest_4way_direction(original: Vector2) -> Vector2:
	if abs(original.x) > abs(original.y):
		if original.x > 0:
			return Vector2.RIGHT
		else:
			return Vector2.LEFT
	
	else:
		if original.y > 0:
			return Vector2.DOWN
		else:
			return Vector2.UP
