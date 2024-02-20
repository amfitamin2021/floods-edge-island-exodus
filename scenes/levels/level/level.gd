class_name Level
extends Node2D

const FOOD_PER_SECOND := 0.5
const MAX_FOOD_AMOUNT := 100.0

@export var final_island: Island = null
@export var current_scene: SceneManager.Scenes
@export var tile_amount := 10

var tiles_spend := 0
var time_spend = 0
var food_amount := MAX_FOOD_AMOUNT
var is_action_press := false
var is_game_on_pause := false
var click_timout : SceneTreeTimer

@onready var tile_map := $TileMap as TileMap
@onready var islands_container := $Islands as Node
@onready var player := $Player as Player
@onready var hud := $Player/Camera2D/HUD as HUD
@onready var end_game_overlay := $EndGameOverlay as EndGameOverlay

func _ready() -> void:
	click_timout = get_tree().create_timer(0.1)
	
	hud.update_block_amount_label(tile_amount)
	hud.set_max_food(MAX_FOOD_AMOUNT)
	hud.update_food_bar(food_amount)
	hud.tile_map = tile_map
	
	for island in islands_container.get_children() as Array[Island]:
		island.mouse_entered.connect(func(): _on_island_mouse_entered(island))
		island.mouse_exited.connect(func(): _on_island_mouse_exited(island))
		island.island_clicked.connect(on_island_clicked)
		add_tiles_from_island(island)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		is_action_press = true
		
	if event.is_action_released("action"):
		is_action_press = false


func _physics_process(delta: float) -> void:
	time_spend += delta

	if is_action_press and hud.active_tool == HUD.Tools.BLOCK:
		draw_ground()


func draw_ground() -> void:
	var tile_pos := tile_map.local_to_map(get_global_mouse_position())
	
	var layer := 1
	var coords: Array[Vector2i] = []
	for x in range(-1, 2):
		for y in range(-1, 2):
			coords.append(Vector2i(tile_pos.x + x, tile_pos.y + y))

	var terrain_set = 0
	var terrain = 1
	
	var tile_data := tile_map.get_cell_tile_data(layer, tile_pos)
	
	if (tile_data == null or tile_data.get_custom_data("is_can_build")) and tile_amount >= 0:
		if tile_amount > 0:
			tile_map.set_cells_terrain_connect(layer, coords, terrain_set, terrain, true)
		update_tiles_amount(tile_amount - 1)


func update_tiles_amount(new_amount: int) -> void:
	if new_amount < 0:
		end_game(false)
	else:
		if new_amount < tile_amount:
			tiles_spend += tile_amount - new_amount
		tile_amount = new_amount
		hud.update_block_amount_label(tile_amount)


func update_food_amount(new_amount: float) -> void:
	food_amount = min(new_amount, MAX_FOOD_AMOUNT)
	hud.update_food_bar(food_amount)
	if food_amount <= 0:
		end_game(false)


func add_tiles_from_island(island: Island) -> void:
	var tiles := island.get_all_tiles()
	island.clear_tile_map()
	for tile in tiles:
		var coords := tile_map.local_to_map(island.global_position + tile.cords)
		tile_map.set_cell(tile.layer, coords, tile.source_id, tile.atlas_coords)


func on_island_clicked(island: Island) -> void:
	if hud.active_tool == hud.Tools.CURSOR:
		if player.can_move_to_island(island):
			player.move_to_island(island)


func on_island_reached(island: Island) -> void:
	if island.is_first_visit:
		update_tiles_amount(tile_amount + island.tile_amount)
		update_food_amount(food_amount + island.food_amount)
	
	if island == final_island:
		end_game(true)


func _on_island_mouse_entered(island: Island) -> void:
	if hud.active_tool == HUD.Tools.CURSOR and not is_game_on_pause:
		if player.can_move_to_island(island):
			island.tile_map.modulate = Color("ffffffff")
		else:
			island.tile_map.modulate = Color("ff0000ff")
		island.tile_map.show()


func _on_island_mouse_exited(island: Island) -> void:
	if hud.active_tool == HUD.Tools.CURSOR and not is_game_on_pause:
		island.tile_map.hide()


func _on_food_timer_timeout():
	if not is_game_on_pause:
		update_food_amount(food_amount - FOOD_PER_SECOND)


func end_game(is_win: bool) -> void:
	is_game_on_pause = true
	end_game_overlay.show_overlay(is_win, round(time_spend), tiles_spend, current_scene)
