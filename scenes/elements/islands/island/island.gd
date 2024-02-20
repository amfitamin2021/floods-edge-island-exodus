class_name Island
extends Area2D

signal island_reached(island: Island)
signal island_clicked(island: Island)
signal island_entered(island: Island)

@export var tile_amount := 12
@export var food_amount := 33
@export var landing_animation_name := ""

var is_first_visit := true

@onready var target_position := ($TargetPosition as Marker2D).global_position
@onready var tile_map := $TileMap as TileMap
@onready var animation_player := $LandingAnimation/AnimationPlayer as AnimationPlayer
@onready var animation_container := $LandingAnimation as Node2D

func _ready() -> void:
	tile_map.hide()
	animation_container.hide()


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("action"):
		island_clicked.emit(self)
		show_selection_effect()


func get_all_tiles() -> Array[TileInfo]:
	var tile_infos: Array[TileInfo] = []
	
	var size := tile_map.get_used_rect()
	for x in range(size.position.x, size.end.x):
		for y in range(size.position.y, size.end.y):
			for z in range(1, 4):
				var source_id = tile_map.get_cell_source_id(z, Vector2i(x,y))
				if source_id != -1:
					var atlas_coords = tile_map.get_cell_atlas_coords(z, Vector2i(x,y))
					var coords = tile_map.map_to_local(Vector2i(x, y))
					tile_infos.append(TileInfo.new(z, coords, source_id, atlas_coords))
	
	return tile_infos


func show_selection_effect() -> void:
	tile_map.set_layer_modulate(4, Color("ffffff34"))
	await get_tree().create_timer(0.3).timeout
	tile_map.set_layer_modulate(4, Color("ffffff14"))


func clear_tile_map() -> void:
	tile_map.clear_layer(0)
	tile_map.clear_layer(1)
	tile_map.clear_layer(2)
	tile_map.clear_layer(3)


func player_enter(player: Player) -> void:
	if is_first_visit and landing_animation_name in animation_player.get_animation_list():
		player.hide()
		animation_container.show()
		animation_player.play(landing_animation_name)
		await animation_player.animation_finished


func player_exit(player: Player) -> void:
	if is_first_visit and landing_animation_name in animation_player.get_animation_list():
		animation_player.play_backwards(landing_animation_name)
		await animation_player.animation_finished
		animation_container.hide()
		player.show()
		is_first_visit = false


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		island_entered.emit(self)
