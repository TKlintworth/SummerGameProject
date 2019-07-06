extends Node2D

func _ready():
	destroy_spear() # spear child not needed until "throw" key is pressed
	
func destroy_spear():
	remove_child($Spear) 