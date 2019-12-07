extends Control

var scene_path_to_load

func _ready() -> void:
	var sounds
	sounds = list_files_in_directory("res://sounds/Lose") # all sounds in directory, list
	print(len(sounds))
	randomize()
	var randIndex = randi() % len(sounds) # int value
	print(randIndex)
	print(sounds)
	print("res://sounds/Lose/"+sounds[randIndex])
	var stream = load("res://sounds/Lose/"+sounds[randIndex])
	$AudioStreamPlayer2D.set_stream(stream)
	$AudioStreamPlayer2D.play(0)

func _on_Button_pressed():
	scene_path_to_load = "res://Scenes/TitleScreen/TitleScreen.tscn"
	get_node("/root/GameStateManager").getScene(scene_path_to_load)
	
#Get all sounds from sounds folder
func list_files_in_directory(path):
    var files = []
    var dir = Directory.new()
    dir.open(path)
    dir.list_dir_begin()

    while true:
        var file = dir.get_next()
        if file == "":
            break
        elif not file.begins_with(".") && not file.ends_with(".import"):
            files.append(file)
    dir.list_dir_end()
    return files
