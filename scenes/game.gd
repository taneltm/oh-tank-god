extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.tanks = %Tanks
	Global.projectiles = %Projectiles
	Global.computer_target = %ComputerTarget
	
	Global.state_change.connect(_on_global_state_change)

func _on_global_state_change(state: Global.GameState) -> void:
	if state == Global.GameState.GAME_OVER:
		print("Game over!")
