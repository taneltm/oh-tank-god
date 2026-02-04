class_name Tank extends CharacterBody2D

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

const SPEED_SLOW   := 20
const SPEED_MEDIUM := 30
const SPEED_FAST   := 40

var speed : int

@export var input_controller : InputController
@export var type := TankType.NONE:
	set(value):
		type = value
		
		var tank_type : String
		
		match value:
			TankType.PLAYER_1:
				tank_type = "yellow"
				speed = SPEED_MEDIUM
			TankType.PLAYER_2:
				tank_type = "blue"
				speed = SPEED_MEDIUM
			TankType.ENEMY_HEAVY:
				tank_type = "green"
				speed = SPEED_SLOW
			TankType.ENEMY_MEDIUM:
				tank_type = "red"
				speed = SPEED_MEDIUM
			TankType.ENEMY_LIGHT_1:
				tank_type = "gray"
				speed = SPEED_FAST
			TankType.ENEMY_LIGHT_2:
				tank_type = "purple"
				speed = SPEED_FAST
			TankType.ENEMY_AMPHIBIAN:
				tank_type = "aqua"
				speed = SPEED_MEDIUM
		
		%AnimatedSprite2D.animation = tank_type


@onready var projectile_spawn_point : Marker2D = %ProjectileSpawnPoint

func _ready() -> void:
	input_controller.shoot.connect(_shoot)

func _physics_process(delta: float) -> void:
	velocity = input_controller.direction * speed
	
	if velocity:
		rotation = input_controller.direction.angle() + TAU / 4
		%AnimatedSprite2D.play()
	else:
		var position_snapped = position.snapped(Vector2(1, 1))

		position.x = move_toward(position.x, position_snapped.x, speed * delta)
		position.y = move_toward(position.y, position_snapped.y, speed * delta)
		%AnimatedSprite2D.pause()
	
	move_and_slide()

func _shoot() -> void:
	Global.shoot(
		projectile_spawn_point.global_position,
		projectile_spawn_point.global_rotation,
	)
	
