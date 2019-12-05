extends Control

func _ready():
	#Allows the pause menu to still be used while games paused
    pause_mode = Node.PAUSE_MODE_PROCESS

func _input(event):
	#by default, the pause keys are "P" and "esc"
	if event.is_action_pressed("pause"):
		#This line just negates the current paused status (toggles pause)
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state


func _on_Main_Menu_pressed():
	#visible = false
	#Unpause the game and move to main menu
	get_tree().paused = false
	GameStateManager.getScene("res://Scenes/TitleScreen/TitleScreen.tscn")
	
	#get_tree().change_scene("res://Scenes/TitleScreen/TitleScreen.tscn")

# Quit the game
func _on_Exit_pressed():
	get_tree().quit()

# Resume the game where you left off
func _on_Resume_pressed():
	var a = InputEventAction.new()
	a.action = "pause"
	a.pressed = true
	Input.parse_input_event(a)

func _on_Controls_pressed():
	$ControlsScreen.visible = true
	$VBoxContainer.visible = false

func _on_Back_pressed() -> void:
	$ControlsScreen.visible = false
	$VBoxContainer.visible = true
