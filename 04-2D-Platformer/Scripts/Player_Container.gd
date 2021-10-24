extends Node2D

onready var Player = load("res://Scene/Player.tscn")
var init_pos = Vector2(121, 372) 

func _process(_delta):
	if not has_node("Player"):
		var player = Player.instance()
		player.position = init_pos
		player.name = "Player"
		add_child(player)
