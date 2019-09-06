extends Node2D

export (PackedScene) var wave_scene
var wave

func _ready():
	pass
	#wave = wave_scene.instance()
	#self.add_child(wave_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("E"):
		get_tree().change_scene("res://Scenes/MainFightScene.tscn")
	if Input.is_action_pressed("T"):
		get_tree().change_scene("res://Scenes/Wave2.tscn")