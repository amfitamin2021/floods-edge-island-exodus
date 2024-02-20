extends Control

func _on_exit_button_pressed():
	SceneManager.exit()

func _on_start_button_pressed():
	SceneManager.change_scene(SceneManager.Scenes.LEVELS_MENU)
