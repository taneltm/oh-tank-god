extends CharacterBody2D

enum TankType {
	NONE,
	PLAYER_1,
	PLAYER_2,
	ENEMY_HEAVY,
	ENEMY_MEDIUM,
	ENEMY_LIGHT_1,
	ENEMY_LIGHT_2,
	ENEMY_AMPHIBIAN,
}

const SPEED = 30.0

@export var input_controller : InputController
@export var model := TankType.NONE:
	set(value):
		model = value
		
		var tank_model : String
		
		match value:
			TankType.PLAYER_1:        tank_model = "yellow"
			TankType.PLAYER_2:        tank_model = "blue"
			TankType.ENEMY_HEAVY:     tank_model = "green"
			TankType.ENEMY_MEDIUM:    tank_model = "red"
			TankType.ENEMY_LIGHT_1:   tank_model = "gray"
			TankType.ENEMY_LIGHT_2:   tank_model = "purple"
			TankType.ENEMY_AMPHIBIAN: tank_model = "aqua"
		
		%AnimatedSprite2D.animation = tank_model


@onready var projectile_spawn_point : Marker2D = %ProjectileSpawnPoint

func _ready() -> void:
	input_controller.shoot.connect(_shoot)

func _physics_process(delta: float) -> void:
	velocity = input_controller.direction * SPEED
	
	if velocity:
		rotation = input_controller.direction.angle() + TAU / 4
		%AnimatedSprite2D.play()
	else:
		position = round(position)
		%AnimatedSprite2D.pause()
	
	move_and_slide()

func _shoot() -> void:
	Global.shoot(
		projectile_spawn_point.global_position,
		projectile_spawn_point.global_rotation,
	)
	
