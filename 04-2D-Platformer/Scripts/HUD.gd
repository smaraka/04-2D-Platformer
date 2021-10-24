extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	update_score()

func update_score():
	$Score.text = "Score: " + str(Global.save_data["score"])
	
