extends Node2D

func _ready():
	remove_child($Spear) # spear child not needed until "throw" key is pressed
