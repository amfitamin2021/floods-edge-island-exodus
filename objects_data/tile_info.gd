class_name TileInfo
extends Object

var layer := -1
var cords := Vector2.ZERO
var source_id := -1
var atlas_coords := Vector2i.ZERO

func _init(
	new_layer: int, new_cords: Vector2, new_source_id: int, new_atlas_coords: Vector2i) -> void:
	layer = new_layer
	cords = new_cords
	source_id = new_source_id
	atlas_coords = new_atlas_coords
