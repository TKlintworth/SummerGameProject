extends Node2D

func _ready():
	destroy_spear() # spear child not needed until "throw" key is pressed
	$Fog/icon/AnimationPlayer.play("fog_in")
	
func destroy_spear():
	remove_child($Spear)
	
func destroy_enemy():
	remove_child($Enemy)