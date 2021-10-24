extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var score = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"score" : score
	}
	return save_dict


func _on_Coin_body_entered(body):
	if body.name == "Player":
		Global.increase_score(score)
		queue_free()
