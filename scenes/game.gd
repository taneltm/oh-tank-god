extends Node2D
@onready var camera_2d: Camera2D = %Camera2D

var LEVEL_COUNT := 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.tanks = %Tanks
	Global.projectiles = %Projectiles
	Global.computer_target = %ComputerTarget
	
	Global.state_change.connect(_on_global_state_change)
	
	# _next_level()

func _on_global_state_change(state: Global.GameState) -> void:
	if state == Global.GameState.GAME_OVER:
		print("Game over!")

func _new_game(number_of_players) -> void:
	print("new game")
	Global.players = number_of_players
	Global.level = 0

	_next_level()

func _next_level() -> void:
	Global.level += 1

	%Camera2D.position = Vector2((Global.level - 1) * 640 * 2, 480 * 2)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start_1"):
		_new_game(1)
	elif event.is_action_pressed("start_2"):
		_new_game(2)
