extends Control

####Important thing learned here: Panel mouse filter was set to Stop because I am using on_mouse_enter to
####highlight the area around the button. However, the panel was blocking the button because the mouse filter for panel
####was set to Stop, or 0, by default. I changed it to Pass (1) and the button is no longer blocked.

#MOUSE_FILTER_STOP = 0 — 
#The control will receive mouse button input events through _gui_input if clicked on. 
#And the control will receive the mouse_entered and mouse_exited signals. 
#These events are automatically marked as handled and they will not propagate further to other controls. 
#This also results in blocking signals in other controls.



var panelStyle = StyleBoxFlat.new()
onready var panel = get_node("HBoxContainer/Maps/Map1/Panel")
onready var panel2 = get_node("HBoxContainer/Maps/Map2/Panel2")
onready var map1Button = get_node("HBoxContainer/Maps/Map1")
onready var map2Button = get_node("HBoxContainer/Maps/Map2")
onready var mapDetails = get_node("HBoxContainer/MapDetails")
onready var menuNoisePlayer = get_node("menuNoise")

var sandyArenaPNG = preload("res://Art/BigArena.png")
var brazierArenaPNG = preload("res://arena/environment/tilesets/wall/walloverview.png")

var map1Descrip = ("Description:\nSandy map free from obstacles.\n\nSize: Large")
var map2Descrip = ""


func _ready() -> void:
	#Go ahead and set the current map buttons mapPaths to be connected to the button pressed signal later
	map1Button.mapPath = "res://Scenes/MainFightScene.tscn"
	map2Button.mapPath = ""
	
	#Go ahead and display map 1 info
	_on_Panel_mouse_entered()
	
	# Set background color of the panelStyle to white-ish
	panelStyle.set_bg_color(Color( 0.98, 0.92, 0.84, 1 ))
	
	# Connect pressed signal from all map select buttons with the path to the buttons map
	for button in $HBoxContainer/Maps.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.mapPath])


func _on_Panel_mouse_entered() -> void:
	menuNoisePlayer.play(0)
	panel.set("custom_styles/panel", panelStyle)
	map1Button.set("custom_colors/font_color", Color( 0, 0, 0, 1 ))
	
	#Set NameOfMap text to nameOfMap in Map button
	#Set MapPic to appropriate thumbnail for map
	#Set map description
	#get_node(String(mapDetails "/NameOfMap")).text = map1Button.nameOfMap
	$HBoxContainer/MapDetails/NameOfMap.text = map1Button.nameOfMap
	#$HBoxContainer/MapDetails/MapPic.set_texture(sandyArenaPNG)
	$HBoxContainer/MapDetails/MapDescrip.text = map1Descrip
	


func _on_Panel2_mouse_entered() -> void:
	menuNoisePlayer.play(0)
	panel2.set("custom_styles/panel", panelStyle)
	map2Button.set("custom_colors/font_color", Color( 0, 0, 0, 1 ))
	
	#Set NameOfMap text to nameOfMap in Map button
	#Set MapPic to appropriate thumbnail for map
	#Set map description
	$HBoxContainer/MapDetails/NameOfMap.text = map2Button.nameOfMap
	#$HBoxContainer/MapDetails/MapPic.set_texture(brazierArenaPNG)
	$HBoxContainer/MapDetails/MapDescrip.text = map2Descrip


func _on_Panel_mouse_exited() -> void:
	panel.set("custom_styles/panel", null)
	map1Button.set("custom_colors/font_color", Color( 0.98, 0.92, 0.84, 1 ))

func _on_Panel2_mouse_exited() -> void:
	panel2.set("custom_styles/panel", null)
	map2Button.set("custom_colors/font_color", Color( 0.98, 0.92, 0.84, 1 ))

func _on_Button_pressed(scene):
	print("button pressed")
	if scene:
		get_node("/root/GameStateManager").getScene(scene)
	else:
		print("Map doesn't exist")

