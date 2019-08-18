extends Label

var wave_number
var wave_string = "Wave "

func _ready():
	wave_number = 1
	self.text = wave_string + str(wave_number) 

# Increase the wave count by 1
func progress():
	wave_number = wave_number + 1
	self.text = wave_string + str(wave_number)

func _process(delta):
	if Input.is_action_just_pressed("M"):
		progress()
