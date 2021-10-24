extends KinematicBody2D


var speed = 1000
var gravity = 1500
var max_speed = 600
var velocity = Vector2.ZERO
var friction = 0.5
var jump = 1000
var resistance = 0.1

onready var sprite = $Sprite
onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var movement_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if movement_x != 0:
		anim.play("Run")
		velocity.x += movement_x * speed * delta
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
		sprite.flip_h = movement_x < 0
		
	if is_on_floor():
		if movement_x == 0:
			velocity.x = lerp(velocity.x, 0, friction)
			anim.play("Idle")
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y -= jump
			anim.play("Jump")
	else:
		if movement_x == 0:
			anim.play("Fall")
			velocity.x = lerp(velocity.x, 0, resistance)
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
