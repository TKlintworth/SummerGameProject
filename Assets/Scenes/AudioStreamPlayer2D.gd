extends AudioStreamPlayer2D

func play_wave_noise():
	#var sound
	#sound = list_files_in_directory("res://sounds/Misc")
	stream = load("res://sounds/Misc/wave_sound_effect.wav")
	play(0)

func _ready():
	pass # Replace with function body.

