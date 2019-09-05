extends Area2D

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
#var zones = ["move1", "move2", "move3", "move4"]
var zones = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zones.append(self.get_node("move1"))
	zones.append(self.get_node("move2"))
	zones.append(self.get_node("move3"))
	zones.append(self.get_node("move4"))
	print(zones)
	for zone in zones:
		print(zone.position)
	
	#var zones = 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
