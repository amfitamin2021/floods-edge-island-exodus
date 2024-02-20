extends Node

enum Scenes
{
	MAIN_MENU,
	LEVELS_MENU,
	LEVEL_1,
	LEVEL_2,
	LEVEL_3,
	LEVEL_4,
}

var name_to_scene := {
	Scenes.MAIN_MENU:preload("res://scenes/scenes/main_menu/main_menu.tscn"),
	Scenes.LEVELS_MENU:preload("res://scenes/scenes/level_selection/level_selection.tscn"),
	Scenes.LEVEL_1:preload("res://scenes/levels/level_1/level_1.tscn"),
	Scenes.LEVEL_2:preload("res://scenes/levels/level_2/level_2.tscn"),
	Scenes.LEVEL_3:preload("res://scenes/levels/level_3/level_3.tscn"),
	Scenes.LEVEL_4:preload("res://scenes/levels/level_4/level_4.tscn")
}

func change_scene(scene_name: Scenes) -> void:
	await SceneAnimations.play_scene_exit()
	get_tree().change_scene_to_packed(name_to_scene[scene_name])
	await SceneAnimations.play_scene_enter()


func exit() -> void:
	await SceneAnimations.play_scene_exit()
	get_tree().quit()
