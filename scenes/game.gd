extends Node2D

@onready var camera_2d: Camera2D = %Camera2D
@onready var intro_tune: AudioStreamPlayer = %IntroTune

var LEVEL_COUNT := 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.tanks = %Tanks
	Global.projectiles = %Projectiles
	Global.state_change.connect(_on_global_state_change)
	Global.level_change.connect(_on_level_change)
	Global.tanks.child_exiting_tree.connect(_on_tank_exit_tree)
	Global.score = %Score
	Global.game_over = %GameOver
	Global.level = 0
	Global.game_over.visible = false
	Global.sfx_shoot = %SfxShoot
	Global.sfx_projectile_collide = %SfxProjectileCollide
	
	intro_tune
	intro_tune.play()
	
	if not Global.debug:
		%Debug.queue_free()

func _on_global_state_change(state: Global.GameState) -> void:
	match state:
		Global.GameState.INTRO:
			%Camera2D.position = Vector2.ZERO
		
		Global.GameState.GAME_OVER:
			await get_tree().create_timer(2).timeout
			%Camera2D.position = Vector2(-1280, 0)
			Global.game_over.visible = true
			await get_tree().create_timer(2).timeout
			get_tree().reload_current_scene()

func _on_level_change(_level: int) -> void:
	print("Level change: ", _level)
	%Camera2D.position = Vector2(Global.get_level_position())
	_destroy_tanks_from_other_levels()

func _new_game(number_of_players) -> void:
	print("New game")
	intro_tune.stop()
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
	await get_tree().create_timer(0.5).timeout

	var tank_counts = _get_tank_counts()
	
	print("Player tanks: %d | Enemy tanks: %d" % [
		tank_counts["player"],
		tank_counts["enemy"],
	])
	
	if tank_counts["player"] > 0 and tank_counts["enemy"] == 0:
		victory()
	elif tank_counts["player"] < 0:
		defeat()

func _get_tank_counts() -> Dictionary:
	var counts := {
		"player": 0,
		"enemy": 0,
	}
	
	for tank in Global.tanks.get_children() as Array[Tank]:
		print(tank.name)
		if tank.is_player:
			counts["player"] += 1
		else:
			counts["enemy"] += 1

	return counts

func victory() -> void:
	await get_tree().create_timer(2).timeout
	_next_level()
	
func defeat() -> void:
	Global.state = Global.GameState.GAME_OVER
