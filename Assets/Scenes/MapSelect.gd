extends Control

# Switch scene to the selected Map.. each button child of Maps should have a path to the level

func _ready() -> void:
	for button in $VBoxContainer/HBoxContainer/Maps.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.map])

func _on_Button_pressed(scene):
	if scene:
		get_node("/root/GameStateManager").getScene(scene)
	else:
		print("Map doesn't exist")