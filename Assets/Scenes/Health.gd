extends TextureProgress
#load an instance of the main fight scene script

#onready var Player = preload("res://Scripts/PlayerController.gd")
#var node = Player.instance()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Testing purposes
	pass

func take_damage(amount):
	if (self.get_value() - amount) <= 0:
		#Player dies
		#instance.set_player_dead(true)
		#print("Script: ", get_node("res://Scripts/PlayerController.gd"))
		#node.set_player_dead(true)
		self.set_value(0)
		#$MainfightScene.play_lose()
		#instance.play_lose()
	else:
		self.set_value(value - amount)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
