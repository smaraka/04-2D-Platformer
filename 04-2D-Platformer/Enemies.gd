extends Node2D


onready var Enemy1 = load("res://Scene/enemy1.tscn")
#var init_pos = Vector2(1499, 118)

func _process(_delta):
	if not has_node("Enemy1"):
		var enemy1 = Enemy1.instance()
		var enemy2 = Enemy1.instance()
		enemy1.name = "Enemy1"
		enemy2.name = "Enemy2"
		add_child(enemy1)
		add_child(enemy2)
