extends Label

var percent = 0.0
var new_wave = true
var wave_string_large = "Wave "
var wave_num_large
var delta2 = 0

func _ready():
	new_wave = true
	self.set_percent_visible(0)
	wave_num_large = get_parent().get_child(2).wave_number
	self.text = wave_string_large + str(wave_num_large)
	


func _process(delta):
	delta2 += delta
	if new_wave == true && percent <= 2:
		percent += delta/2
		self.set_percent_visible(percent)
		
		#if delta2 > .3:
		#	get_parent().get_parent().get_node("AudioStreamPlayer2D").play_wave_noise()
		#	delta2 = 0
			
	elif percent > 2:
		new_wave = false
		percent = 0
		self.set_percent_visible(percent)
	#print(percent)
	#print("d2 " + str(delta2))
	
func change_wave():
	new_wave = true
	wave_num_large = get_parent().get_child(2).wave_number
	self.text = wave_string_large + str(wave_num_large)
