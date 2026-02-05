class_name Projectile extends Area2D

const INITIAL_VELOCITY = 100
const IMPACT_VELOCITY = 20

var velocity := INITIAL_VELOCITY

@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D

var has_collided = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await sprite.animation_finished
	sprite.play("fly")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2.from_angle(rotation) * velocity * delta


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if has_collided: return
	
	has_collided = true

	if body is TileMapLayer:
		_on_tile_collision(body, body_shape_index)
		
	velocity = IMPACT_VELOCITY
	sprite.play("destroy")
	await sprite.animation_finished
	queue_free()

func _on_tile_collision(tile_map_layer: TileMapLayer, body_shape_index: int) -> void:
	var local_position = tile_map_layer.to_local(global_position)
	var map_coord = tile_map_layer.local_to_map(local_position)
	var tile_data = tile_map_layer.get_cell_tile_data(map_coord)
	var hp = tile_data.get_custom_data("hit_points") if tile_data else null
	var is_flag = tile_data.get_custom_data("is_flag") if tile_data else null
	
	if hp:
		var cell_source_id = tile_map_layer.get_cell_source_id(map_coord)
		var atlas_coords = tile_map_layer.get_cell_atlas_coords(map_coord)

		atlas_coords.x += 1
		tile_map_layer.set_cell(map_coord, cell_source_id, atlas_coords)

	elif is_flag:
		var cell_source_id = tile_map_layer.get_cell_source_id(map_coord)
		var atlas_coords = tile_map_layer.get_cell_atlas_coords(map_coord)

		atlas_coords.y += 1
		tile_map_layer.set_cell(map_coord, cell_source_id, atlas_coords)
		
		Global.state = Global.GameState.GAME_OVER
