class_name Projectile extends Area2D

const INITIAL_VELOCITY := 100
const IMPACT_VELOCITY  := 20

var velocity             := INITIAL_VELOCITY
var has_collided         := false
var is_player_projectile := false

@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await sprite.animation_finished
	sprite.play("fly")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2.from_angle(rotation) * velocity * delta


func _on_body_shape_entered(
	_body_rid: RID,
	body: Node2D,
	body_shape_index: int,
	_local_shape_index: int,
) -> void:
	if has_collided: return
	
	has_collided = true

	if body is TileMapLayer:
		_on_tile_collision(body, body_shape_index)
	
	elif body is Tank:
		_on_tank_collision(body)
		
	velocity = IMPACT_VELOCITY
	sprite.play("destroy")
	await sprite.animation_finished
	queue_free()

func _on_tile_collision(tile_map_layer: TileMapLayer, _body_shape_index: int) -> void:
	var local_position := tile_map_layer.to_local(global_position)
	var map_coord      := tile_map_layer.local_to_map(local_position)
	var tile_data      := tile_map_layer.get_cell_tile_data(map_coord)
	var cell_source_id := tile_map_layer.get_cell_source_id(map_coord)
	var atlas_coords   := tile_map_layer.get_cell_atlas_coords(map_coord)
	var hp             := tile_data.get_custom_data("hit_points") as bool if tile_data else false
	var is_flag        := tile_data.get_custom_data("is_flag") as bool if tile_data else false

	if hp:
		_on_destroyable_tile_collision(tile_map_layer, map_coord, cell_source_id, atlas_coords)

	elif is_flag:
		_on_flag_tile_collision(tile_map_layer, map_coord, cell_source_id, atlas_coords)

func _on_destroyable_tile_collision(
	tile_map_layer: TileMapLayer,
	map_coord: Vector2i,
	cell_source_id: int,
	atlas_coords: Vector2i,
) -> void:
	atlas_coords.x += 1
	tile_map_layer.set_cell(map_coord, cell_source_id, atlas_coords)

func _on_flag_tile_collision(
	tile_map_layer: TileMapLayer,
	map_coord: Vector2i,
	cell_source_id: int,
	atlas_coords: Vector2i,
) -> void:
	atlas_coords.y += 1
	tile_map_layer.set_cell(map_coord, cell_source_id, atlas_coords)
	
	Global.state = Global.GameState.GAME_OVER

func _on_tank_collision(tank: Tank) -> void:
	var is_friendly_fire = (
		is_player_projectile and tank.is_player or
		!is_player_projectile and !tank.is_player
	)
	
	if is_friendly_fire: return
	
	tank.destroy()
