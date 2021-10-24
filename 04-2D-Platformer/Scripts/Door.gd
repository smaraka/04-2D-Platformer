extends Area2D


func _ready():
	pass # Replace with function body.



func _on_Door_body_entered(body):
	if Global.save_data["level"] == 1:
		Global.save_data["level"] == 2
		var _s = get_tree().change_scene("res://Scene/Level2.tscn")
