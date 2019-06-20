extends AudioStreamPlayer2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var sounds
	sounds = list_files_in_directory("res://sounds")
	print(len(sounds))
	randomize()
	var randIndex = randi() % len(sounds)
	print(randIndex)
	print(sounds)
	print("res://sounds/"+sounds[randIndex])
	stream = load("res://sounds/"+sounds[randIndex])
	print(stream)
	play(0)
	

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
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
