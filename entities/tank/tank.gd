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

var powerup_timer := Timer.new()
var powerup_type := Powerup.Type.NONE

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
	
	powerup_timer.one_shot = true
	powerup_timer.timeout.connect(powerup_remove)
	add_child(powerup_timer)

func _physics_process(delta: float) -> void:
	if Global.state == Global.GameState.GAME_OVER: return
	if _is_destroyed == true: return
	
	var speed_multiplier = 1.0 if not powerup_type == Powerup.Type.GAS else 2.0

	velocity = input_controller.direction * _speed * speed_multiplier
	
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
	if Global.state == Global.GameState.GAME_OVER: return
	if _is_destroyed == true: return

	var is_piercing = powerup_type == Powerup.Type.PIERCING

	Global.shoot(
		projectile_spawn_point.global_position,
		projectile_spawn_point.global_rotation,
		is_player,
		is_piercing,
	)
	
func destroy() -> void:
	if powerup_type == Powerup.Type.SHIELD: return
	if _is_destroyed == true: return
	
	_is_destroyed = true
	
	%AnimatedSprite2D.play(%AnimatedSprite2D.animation + "_explosion")
	await %AnimatedSprite2D.animation_finished

	queue_free()

func powerup(p_type: Powerup.Type) -> void:
	print("Powerup!")
	powerup_type = p_type
	powerup_timer.wait_time = 10
	powerup_timer.start()
	
func powerup_remove() -> void:
	print("Powerup ended")
	powerup_type = Powerup.Type.NONE
