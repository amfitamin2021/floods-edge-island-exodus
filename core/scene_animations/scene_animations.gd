extends CanvasLayer

@onready var animation_player := $AnimationPlayer as AnimationPlayer

func play_scene_enter() -> void:
	animation_player.play_backwards('dissolve')
	await animation_player.animation_finished

func play_scene_exit() -> void:
	animation_player.play('dissolve')
	await animation_player.animation_finished
