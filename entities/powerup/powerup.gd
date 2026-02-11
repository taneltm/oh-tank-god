class_name Powerup extends Area2D

enum Type {
	NONE,
	SHIELD,
	GAS,
	PIERCING,
}

var type : Type

func _ready() -> void:
	type = [1, 2, 3].pick_random()
	
	match type:
		Type.SHIELD:
			%AnimatedSprite2D.play("shield")

		Type.GAS:
			%AnimatedSprite2D.play("gas")

		Type.PIERCING:
			%AnimatedSprite2D.play("piercing")

func _on_body_shape_entered(
	_body_rid: RID,
	body: Node2D,
	_body_shape_index: int,
	_local_shape_index: int
) -> void:
	if body is Tank:
		_on_tank_collision(body)

func _on_tank_collision(tank: Tank) -> void:	
	tank.powerup(type)
	queue_free()
