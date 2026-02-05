class_name InputControllerCpu extends InputController

var debug_nodes = {}

const POSSIBLE_DIRECTIONS = [
	Vector2.UP,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.RIGHT
]

@onready var this_tank : Tank = get_parent()

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	match controller_type:
		ControllerType.COMPUTER_EASY:   _ai_loop_easy()
		ControllerType.COMPUTER_MEDIUM: _ai_loop_medium()
		ControllerType.COMPUTER_HARD:   _ai_loop_hard()
		
	if Global.debug: _debug_init()
		

func _debug_init() -> void:
	debug_nodes["line_to_target"] = Line2D.new()
	debug_nodes["line_to_target_4way"] = Line2D.new()
	debug_nodes["line_to_p1"] = Line2D.new()
	debug_nodes["line_to_p1_4way"] = Line2D.new()
	
	debug_nodes["line_to_target"].width = 1
	debug_nodes["line_to_target_4way"].width = 1
	debug_nodes["line_to_p1"].width = 1
	debug_nodes["line_to_p1_4way"].width = 1
	debug_nodes["line_to_target"].default_color = Color(0, 1, 0, 1)
	debug_nodes["line_to_target_4way"].default_color = Color(1, 0, 0, 1)
	debug_nodes["line_to_p1"].default_color = Color(1.0, 1.0, 0.0, 1.0)
	debug_nodes["line_to_p1_4way"].default_color = Color(1.0, 0.51, 0.0, 1.0)

	get_tree().root.add_child(debug_nodes["line_to_target"])
	get_tree().root.add_child(debug_nodes["line_to_target_4way"])
	get_tree().root.add_child(debug_nodes["line_to_p1"])
	get_tree().root.add_child(debug_nodes["line_to_p1_4way"])
	
	_debug_loop()
	
func _debug_loop() -> void:
	var line_to_target : Line2D = debug_nodes["line_to_target"]
	var line_to_target_4way : Line2D = debug_nodes["line_to_target_4way"]
	var line_to_p1 : Line2D = debug_nodes["line_to_p1"]
	var line_to_p1_4way : Line2D = debug_nodes["line_to_p1_4way"]
	
	line_to_target.clear_points()
	line_to_target.add_point(get_parent().global_position)
	line_to_target.add_point(Global.computer_target.global_position)
	
	line_to_target_4way.clear_points()
	line_to_target_4way.add_point(get_parent().global_position)
	line_to_target_4way.add_point((
		get_parent().global_position +
		_4way_clamp(_get_direction_to_target_marker()) * 200
	))

	line_to_p1.clear_points()
	line_to_p1.add_point(get_parent().global_position)
	line_to_p1.add_point(
		get_parent().global_position +
		_get_direction_to_target_tank(Tank.TankType.PLAYER_1) * 100
	)
	
	line_to_p1_4way.clear_points()
	line_to_p1_4way.add_point(get_parent().global_position)
	line_to_p1_4way.add_point(
		get_parent().global_position +
		_4way_clamp(_get_direction_to_target_tank(Tank.TankType.PLAYER_1)) * 100
	)
	
	await get_tree().create_timer(0.25).timeout
	_debug_loop()

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
	
	if randi_range(0, 4):
		direction_choices.append(_4way_clamp(_get_direction_to_target_tank(Tank.TankType.PLAYER_1)))
		direction_choices.append(_4way_clamp(_get_direction_to_target_tank(Tank.TankType.PLAYER_2)))
	else:
		direction_choices.append_array(POSSIBLE_DIRECTIONS)
	
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
	direction = _4way_clamp(_get_direction_to_target_marker())
	
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
	var target = Global.computer_target.global_position

	for tank in Global.tanks.get_children() as Array[Tank]:
		if tank.type == tank_type:
			target = tank.global_position
			break
			
	var exact_direction = this_tank.global_position.direction_to(target)
	
	return exact_direction
	
func _get_direction_to_target_marker() -> Vector2:
	var target = Global.computer_target.global_position
	
	return this_tank.global_position.direction_to(target)
	
func _4way_clamp(original: Vector2) -> Vector2:
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
