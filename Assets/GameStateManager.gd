# THIS IS THE GAME STATE MANAGER. USE THIS FOR GLOBAL VARIABLES AND CHANGING SCENES

extends Node

var currentScene = null
var playerName = "slave"

# Accessor for player name
func getPlayerName():
	return playerName
	
func _ready():
	currentScene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1) # gets null scene

# USE THIS FUNCTION FOR CHANGING SCENES
func getScene(scene):
	#get_tree().change_scene(scene)
	currentScene.queue_free()
	var s = ResourceLoader.load(scene)
	currentScene = s.instance();
	get_tree().get_root().add_child(currentScene)
	