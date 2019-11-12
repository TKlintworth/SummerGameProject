extends AudioStreamPlayer2D


func play_enemy_death_noise():
	var sounds
	sounds = list_files_in_directory("res://sounds/Enemy") # all sounds in directory, list
	print(len(sounds))
	randomize()
	var randIndex = randi() % len(sounds) # int value
	print(randIndex)
	print(sounds)
	print("res://sounds/Enemy/"+sounds[randIndex])
	stream = load("res://sounds/Enemy/"+sounds[randIndex])
	print(stream)
	play(0)

func play_attack_noise():
	var sounds
	sounds = list_files_in_directory("res://sounds/Attack")
	print(len(sounds))
	randomize()
	var randIndex = randi() % len(sounds)
	print(randIndex)
	print(sounds)
	print("res://sounds/Attack/"+sounds[randIndex])
	stream = load("res://sounds/Attack/"+sounds[randIndex])
	print(stream)
	play(0)

func play_wave_noise():
	#var sound
	#sound = list_files_in_directory("res://sounds/Misc")
	stream = load("res://sounds/Misc/1A_Colosseum.wav")
	play(0)



func play_menu_music():
	stream = load("res://sounds/Music/MenuMusic.wav")
	play(0)



func _ready():
	pass
	

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
