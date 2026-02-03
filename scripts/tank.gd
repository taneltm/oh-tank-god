extends CharacterBody2D

@export var input_controller : InputController

const SPEED = 30.0


func _physics_process(delta: float) -> void:
	velocity = input_controller.direction * SPEED
	
	if velocity:
		rotation = input_controller.direction.angle() + TAU / 4
		%AnimatedSprite2D.play()
	else:
		%AnimatedSprite2D.pause()
	
	move_and_slide()
