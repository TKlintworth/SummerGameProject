extends AudioStreamPlayer

# Declare member variables here. Examples:
# var a: int = 2
onready var menuClick1 = load("res://sounds/Misc/menuclick.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream = menuClick1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
