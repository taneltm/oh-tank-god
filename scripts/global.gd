extends Node

enum GameState {
	MENU,
	LEVEL_1,
	GAME_OVER,
}

signal state_change

var levels := [
	
]

var state := GameState.LEVEL_1:
	set(value):
		state = value
		state_change.emit(value)

const PROJECTILE = preload("uid://btnls06kb2edv")

var debug = false

var players : int = 0
var level : int = 0
var score : int = 0
var tanks : Node2D
var projectiles : Node2D
var computer_target : Node2D

func shoot(position: Vector2, rotation: float) -> void:
	var projectile : Projectile = PROJECTILE.instantiate()
	
	projectile.position = position
	projectile.rotation = rotation

	projectiles.add_child(projectile)
