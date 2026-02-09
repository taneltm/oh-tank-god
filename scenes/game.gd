extends Node2D
@onready var camera_2d: Camera2D = %Camera2D

var LEVEL_COUNT := 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.tanks = %Tanks
	Global.projectiles = %Projectiles
	Global.state_change.connect(_on_global_state_change)
	Global.level_change.connect(_on_level_change)
	Global.tanks.child_exiting_tree.connect(_on_tank_exit_tree)
	Global.score = %Score
	Global.level = 0
	
	if not Global.debug:
		%Debug.queue_free()

func _on_global_state_change(state: Global.GameState) -> void:
	match state:
		Global.GameState.INTRO:
			%Camera2D.position = Vector2.ZERO
		
		Global.GameState.GAME_OVER:
			print("Game over!")

func _on_level_change(_level: int) -> void:
	print("Level change: ", _level)
	%Camera2D.position = Vector2(Global.get_level_position())
	_destroy_tanks_from_other_levels()

func _new_game(number_of_players) -> void:
	print("New game")
	Global.players = number_of_players
	Global.state = Global.GameState.PLAYING
	Global.score.text = "0"
	Global.level = 1

func _next_level() -> void:
	Global.level += 1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start_1"):
		_new_game(1)
	elif event.is_action_pressed("start_2"):
		_new_game(2)

func _destroy_tanks_from_other_levels() -> void:
	for tank in Global.tanks.get_children() as Array[Tank]:
		if not Global.get_level_rect().has_point(tank.position):
			tank.queue_free()

func _on_tank_exit_tree(_tank: Tank) -> void:
	var tank_counts = _get_tank_counts()
	
	if tank_counts["player"] > 0 and tank_counts["enemy"] == 0:
		Global.victory()
	elif tank_counts["player"] < 0:
		Global.defeat()

func _get_tank_counts() -> Dictionary:
	var counts := {
		"player": 0,
		"enemy": 0,
	}
	
	for tank in Global.tanks.get_children() as Array[Tank]:
		if tank.is_player:
			counts["player"] += 1
		else:
			counts["enemy"] += 1

	return counts
