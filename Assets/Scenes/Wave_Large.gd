extends Label

var percent = 0.0
var new_wave = true
var wave_string_large = "Wave "
var wave_num_large = 1
var delta2 = 0
var scene_path_to_load

func _ready():
	new_wave = true
	self.set_percent_visible(0)
	#wave_num_large = get_parent().get_child(2).wave_number
	#wave_num_large = 
	self.text = wave_string_large + str(wave_num_large)
	


func _process(delta):
	delta2 += delta
	if new_wave == true && percent <= 2:
		percent += delta/2
		self.set_percent_visible(percent)

	elif percent > 2:
		new_wave = false
		percent = 0
		self.set_percent_visible(percent)
		get_tree().get_root().get_child(1).play_battle_music()
		#load scene
		#scene_path_to_load = "res://Scenes/Wave2.tscn"
		#get_tree().change_scene(scene_path_to_load)
	#print(percent)
	#print("d2 " + str(delta2))
	
func change_wave():
	new_wave = true
	wave_num_large += 1
	print(get_tree().get_root().get_child(1).wave_num)
	print("wave_num_large")
	print(wave_num_large)
	self.text = wave_string_large + str(wave_num_large)
