extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dragging
var drag_start = Vector2()
# Called when the node enters the scene tree for the first time.

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("click") and not dragging:
		print("dragging true")
		dragging = true
		drag_start = get_global_mouse_position()
	if event.is_action_released("click") and dragging:
		print("dragging false")
		dragging = false
		var drag_end = get_global_mouse_position()
		var dir = drag_start - drag_end
		apply_impulse(Vector2(), dir * 5)
		

#func _process(delta):
#	if(Input.is_key_pressed(KEY_T)):
#		apply_impulse(Vector2(), Vector2(50,5))
