class_name HUD
extends CanvasLayer

enum Tools {CURSOR, BLOCK}

@onready var button_cursor := %Cursor as Button
@onready var button_block := %Block as Button
@onready var food_bar := %FoodBar as ProgressBar
@onready var block_amount_label := %BlockAmountLabel as Label
@onready var block_projection := $Sprite2D as Sprite2D

var active_tool := Tools.CURSOR as Tools
var tile_map : TileMap

func _ready() -> void:
	block_projection.hide()
	button_cursor.grab_focus()

	food_bar.value = 100


func _input(event) -> void:
	if event.is_action_pressed("tool_1") \
	or event.is_action_pressed("tool_2") \
	or event.is_action_pressed("tool_next") \
	or event.is_action_pressed("tool_previous"):
		if active_tool == Tools.BLOCK:
			active_tool = Tools.CURSOR
			button_cursor.grab_focus()
			block_projection.hide()
			
		elif active_tool == Tools.CURSOR:
			active_tool = Tools.BLOCK
			button_block.grab_focus()
			block_projection.show()
	


func _process(_delta):
	if active_tool:
		var mouse_cord := tile_map.to_local(get_viewport().get_mouse_position())
		var coords_tile := tile_map.local_to_map(mouse_cord)
		block_projection.position = tile_map.map_to_local(coords_tile)


func _on_cursor_toggled(_button_pressed: bool) -> void:
	block_projection.hide()
	active_tool = Tools.CURSOR


func _on_block_toggled(_button_pressed: bool) -> void:
	block_projection.show()
	active_tool = Tools.BLOCK


func update_food_bar(new_value: float) -> void:
	food_bar.value = new_value


func set_max_food(amount: float) -> void:
	food_bar.max_value = amount


func update_block_amount_label(new_value: int) -> void:
	block_amount_label.text = str(new_value)
