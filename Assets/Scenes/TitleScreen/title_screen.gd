extends Control

var scene_path_to_load
var scene_to_load

func _ready():
	$AudioStreamPlayer2D.play_menu_music() # play menu music
	$Menu/CenterRow/Buttons/NewGameButton.grab_focus()
	for button in $Menu/CenterRow/Buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])
		#print("hello")

func _on_Button_pressed(scene):
	#Fixed Main Menu...
	#If you press one of the main menu buttons and it has scene_to_load, set scene_to_load to this scene. Fade to that scene
	if scene:
		scene_to_load = scene
		$FadeIn.show()
		$FadeIn.fade_in()
	else:
		print("Null scene to load")
	#res://Game/Options.tscn
	#scene_path_to_load = "res://Scenes/MainFightScene.tscn"
	#scene_path_to_load = scene_to_load
	


func _on_FadeIn_fade_finished():
	#get_node("/root/GameStateManager").getScene(scene_path_to_load)
	get_node("/root/GameStateManager").getScene(scene_to_load)
