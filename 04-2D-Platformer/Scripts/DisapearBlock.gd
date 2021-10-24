extends Area2D

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			$AnimationPlayer.play("destroyed")
			yield($AnimationPlayer, "animation_finished")
			queue_free()
		else:
			$AnimationPlayer.play("idle")
