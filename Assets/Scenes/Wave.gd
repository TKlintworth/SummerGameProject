extends Label

var wave_number = 1
var wave_string = "Wave: "

func _ready():
	#wave_number = 1
	self.text = wave_string + str(wave_number) 

# Increase the wave count by 1
func progress():
	wave_number = wave_number + 1
	print("wave_number")
	print(wave_number)
	self.text = wave_string + str(wave_number)
	get_parent().get_child(3).change_wave()
	get_parent().get_child(3).percent = 0

func _process(delta):
	if Input.is_action_just_pressed("M"):
		progress()
