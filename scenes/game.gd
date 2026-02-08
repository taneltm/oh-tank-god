extends Node2D
@onready var camera_2d: Camera2D = %Camera2D

var LEVEL_COUNT := 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.tanks = %Tanks
	Global.projectiles = %Projectiles
	Global.state_change.connect(_on_global_state_change)
	Global.level_change.connect(_on_level_change)
	
	Global.level = 0

func _on_global_state_change(state: Global.GameState) -> void:
	match state:
		Global.GameState.INTRO:
			%Camera2D.position = Vector2.ZERO
		
		Global.GameState.GAME_OVER:
			print("Game over!")

func _on_level_change(_level: int) -> void:
	print("Level change: ", _level)
	%Camera2D.position = Vector2(Global.get_level_position())

func _new_game(number_of_players) -> void:
	print("New game")
	Global.players = number_of_players
	Global.state = Global.GameState.PLAYING
	Global.level = 1

func _next_level() -> void:
	Global.level += 1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start_1"):
		_new_game(1)
	elif event.is_action_pressed("start_2"):
		_new_game(2)
