class_name EndGameOverlay
extends CanvasLayer

var current_scene : SceneManager.Scenes 
var is_open := false

@onready var header_label := %Header as Label
@onready var time_label := %TimeLabel as Label
@onready var tile_label := %TileLabel as Label

@onready var animation_player := $AnimationPlayer as AnimationPlayer

func _ready():
	hide()

func show_overlay(result: bool, transit_time: int, amount_spent_tiles: int, scene_name: SceneManager.Scenes) -> void:
	if is_open:
		return
	is_open = true
	save_level_data(str(scene_name), result, transit_time, amount_spent_tiles)
	current_scene = scene_name
	show()
	animation_player.play("appearance_overlay")
	if result:
		header_label.text = "ПОБЕДА"
	else:
		header_label.text = "НЕУДАЧА"
	
	time_label.text = time_to_str(transit_time)
	tile_label.text = str(amount_spent_tiles)

func save_level_data(level_name: String, is_win: bool, time: int, tiles: int) -> void:
	var old_data := LevelsStorage.get_level_data(level_name)
	
	var data = LevelData.new()
	data.state = old_data.state
	if is_win:
		data.name = level_name
		data.state = LevelData.States.PASSED
		data.amount_spent_tiles = min(old_data.amount_spent_tiles if old_data.amount_spent_tiles != 0 else tiles, tiles)
		data.transit_time = min(old_data.transit_time, time)
		
		LevelsStorage.save_level_data(data)


func _on_start_game_button_pressed():
	SceneManager.change_scene(SceneManager.Scenes.LEVELS_MENU)


func _on_reset_game_button_pressed():
	SceneManager.change_scene(current_scene)


func time_to_str(time: float) -> String:
	var secs := fmod(time, 60)
	var mins := fmod(time, 60*60) / 60
	return "%02d:%02d" % [mins, secs]
