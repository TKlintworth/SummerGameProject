extends Control

func _ready():
	$AudioStreamPlayer2D.play_menu_music()
	
func _on_Button_pressed():
	get_tree().change_scene('res://Scenes/TitleScreen/TitleScreen.tscn')
