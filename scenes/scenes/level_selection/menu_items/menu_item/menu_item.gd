class_name MenuItem
extends Node2D

signal level_selected(index: int)

const SPRITES := {
	LevelData.States.OPEN: preload("res://assets/level_open_marker.png"),
	LevelData.States.CLOSE: preload("res://assets/level_close_marker.png"),
	LevelData.States.PASSED: preload("res://assets/level_passed_marker.png"),
}

@export var label := ""
@export var description := ""
@export var scene : SceneManager.Scenes

var level_data: LevelData = null
var index := 0

@onready var sprite := $Sprite2D as Sprite2D
@onready var button := $Button as Button

func _ready() -> void:
	level_data = LevelsStorage.get_level_data(str(scene))
	change_state(level_data.state)

func change_state(new_state: LevelData.States) -> void:
	level_data.state = new_state
	sprite.texture = SPRITES[level_data.state]


func _on_button_toggled(_button_pressed: bool) -> void:
	level_selected.emit(index)

func grab_focus() -> void:
	button.grab_focus()

func start_game() -> void:
	SceneManager.change_scene(scene)
