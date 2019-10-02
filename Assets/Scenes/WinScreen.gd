extends Control

var scene_path_to_load

func _on_Button_pressed():
	scene_path_to_load = "res://Scenes/TitleScreen/TitleScreen.tscn"
	get_node("/root/GameStateManager").getScene(scene_path_to_load)
