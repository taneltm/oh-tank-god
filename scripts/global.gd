extends Node

var debug = false

enum GameState {
	INTRO,
	PLAYING,
	GAME_OVER,
}

signal state_change
signal level_change

var state := GameState.INTRO:
	set(value):
		state = value
		state_change.emit(value)

var level : int = -1:
	set(value):
		level = value
		level_change.emit(value)

const PROJECTILE = preload("uid://btnls06kb2edv")

var players : int = 0
var tanks : Node
var projectiles : Node
var computer_target : Node2D
var camera : Camera2D
var score : Label
var game_over : BoxContainer
var game_over_label : Label
var sfx_shoot : AudioStreamPlayer
var sfx_projectile_collide : AudioStreamPlayer
var sfx_powerup : AudioStreamPlayer
var sfx_powerdown : AudioStreamPlayer

func shoot(
	position: Vector2,
	rotation: float,
	is_player_projectile: bool,
	is_piercing: bool
) -> void:
	var projectile : Projectile = PROJECTILE.instantiate()
	
	projectile.position = position
	projectile.rotation = rotation
	projectile.is_player_projectile = is_player_projectile
	projectile.is_piercing = is_piercing

	projectiles.add_child(projectile)

func get_level_position() -> Vector2:
	return Vector2(level * 640 * 2, 0)
	
func get_level_rect() -> Rect2:
	return Rect2(Global.get_level_position(), Vector2(640, 480))
