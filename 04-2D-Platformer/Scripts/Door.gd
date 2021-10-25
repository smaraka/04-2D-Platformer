extends Area2D


func _ready():
	pass # Replace with function body.



func _on_Door_body_entered(body):
	if Global.save_data["level"] == 1:
		var _s = get_tree().change_scene("res://Scene/Level2.tscn")
		Global.save_data["level"] == 2
	else:
		var _s = get_tree().change_scene("res://Scene/Level1.tscn")
