extends CharacterBody2D

@export var input_controller : InputController

@onready var projectile_spawn_point : Marker2D = %ProjectileSpawnPoint

const SPEED = 30.0

func _ready() -> void:
	input_controller.shoot.connect(_shoot)

func _physics_process(delta: float) -> void:
	velocity = input_controller.direction * SPEED
	
	if velocity:
		rotation = input_controller.direction.angle() + TAU / 4
		%AnimatedSprite2D.play()
	else:
		%AnimatedSprite2D.pause()
	
	move_and_slide()

func _shoot() -> void:
	Global.shoot(
		projectile_spawn_point.global_position,
		projectile_spawn_point.global_rotation,
	)
	
