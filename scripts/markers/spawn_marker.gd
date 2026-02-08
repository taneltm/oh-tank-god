class_name SpawnMarker extends Marker2D

enum Difficulty {
	NONE,
	EASY,
	MEDIUM,
	HARD,
}

@export var tank_type := Tank.TankType.NONE
@export var controller_type = InputController.ControllerType.COMPUTER_MEDIUM

const TANK = preload("uid://b3wwr2tbjc420")

func _ready() -> void:
	Global.level_change.connect(_on_level_change)
	
func _on_level_change(_level: int) -> void:
	if Global.get_level_rect().has_point(position):
		_spawn()
		
func _spawn() -> void:
	var is_skip_player2_spawn = (
		controller_type == InputController.ControllerType.PLAYER_2 and
		Global.players != 2
	)
	
	if is_skip_player2_spawn: return
	
	var tank : Tank = TANK.instantiate()
	
	var is_player = (
		controller_type == InputController.ControllerType.PLAYER_1 ||
		controller_type == InputController.ControllerType.PLAYER_2
	) 
	
	var controller : InputController
	
	if is_player:
		controller = InputControllerPlayer.new() 
	else:
		controller = InputControllerCpu.new()
		tank.rotation = _get_random_rotation()
	
	controller.controller_type = controller_type
	
	tank.add_child(controller)
	tank.type = tank_type
	tank.input_controller = controller
	tank.position = position
	
	Global.tanks.add_child(tank)

func _get_random_rotation() -> float:
	var random_direction : Vector2 = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2. RIGHT].pick_random()
	
	return random_direction.angle()
