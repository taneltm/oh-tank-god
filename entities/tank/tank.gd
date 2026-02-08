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

var _speed : int
var _is_destroyed := false
var is_player := false

@export var input_controller : InputController
@export var type := TankType.NONE:
	set(value):
		type = value
		
		var tank_type : String
		
		match value:
			TankType.PLAYER_1:
				is_player = true
				tank_type = "yellow"
				_speed = SPEED_MEDIUM

			TankType.PLAYER_2:
				is_player = true
				tank_type = "blue"
				_speed = SPEED_MEDIUM

			TankType.ENEMY_HEAVY:
				tank_type = "green"
				_speed = SPEED_SLOW

			TankType.ENEMY_MEDIUM:
				tank_type = "red"
				_speed = SPEED_MEDIUM

			TankType.ENEMY_LIGHT_1:
				tank_type = "gray"
				_speed = SPEED_FAST

			TankType.ENEMY_LIGHT_2:
				tank_type = "purple"
				_speed = SPEED_FAST

			TankType.ENEMY_AMPHIBIAN:
				tank_type = "aqua"
				_speed = SPEED_MEDIUM
		
		%AnimatedSprite2D.animation = tank_type


@onready var projectile_spawn_point : Marker2D = %ProjectileSpawnPoint

func _ready() -> void:
	input_controller.shoot.connect(_shoot)

func _physics_process(delta: float) -> void:
	if _is_destroyed == true: return

	velocity = input_controller.direction * _speed
	
	if velocity:
		rotation = input_controller.direction.angle() + TAU / 4
		%AnimatedSprite2D.play()
	else:
		var position_snapped = position.snapped(Vector2(1, 1))

		position.x = move_toward(position.x, position_snapped.x, _speed * delta)
		position.y = move_toward(position.y, position_snapped.y, _speed * delta)
		%AnimatedSprite2D.pause()
	
	move_and_slide()

func _shoot() -> void:
	if _is_destroyed == true: return

	Global.shoot(
		projectile_spawn_point.global_position,
		projectile_spawn_point.global_rotation,
		is_player,
	)
	
func destroy() -> void:
	if _is_destroyed == true: return
	
	input_controller.shoot.disconnect(_shoot)
	
	%AnimatedSprite2D.play(%AnimatedSprite2D.animation + "_explosion")
	await %AnimatedSprite2D.animation_finished

	queue_free()
	
