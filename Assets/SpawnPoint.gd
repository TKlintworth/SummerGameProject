extends Position2D

#Path to enemy that you want to spawn
#Time in between spawns
export (PackedScene) var enemyScene
export (String) var enemyPath
export (int) var spawnInterval

#onready var enemyScene = get_node("res://Scenes/Enemy.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start()

#DEBUG...NOT INTENDED
func _start():
	var enemy = enemyScene.instance()
	add_child(enemy)
	enemy.position = self.position

