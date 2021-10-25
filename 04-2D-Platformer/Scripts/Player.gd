extends KinematicBody2D


var speed = 1000
var gravity = 380
var max_speed = 600
var velocity = Vector2.ZERO
var friction = 0.5
var jump = 1200
var resistance = 0.7
var jumpNum = 0
var wallJump = 250
var jumpWall = 20

#dash
var dashDirection = Vector2(1, 0)
var dashable = false
var isDash = false

onready var sprite = $Sprite
onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	dash()
	gravity = 2500
	var movement_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if movement_x != 0:
		anim.play("Run")
		velocity.x += movement_x * speed * delta
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
		sprite.flip_h = movement_x < 0
		
	if is_on_floor() or nextToWall():
		jumpNum = 2
		if movement_x == 0:
			velocity.x = lerp(velocity.x, 0, friction)
			anim.play("Idle")
		if Input.is_action_just_pressed("ui_accept") and jumpNum > 0:
			velocity.y -= jump
			jumpNum -= 1
			if not is_on_floor() and nextRight():
				velocity.x += wallJump
				velocity.y -= jumpWall
			if not is_on_floor() and nextLeft():
					velocity.x -= wallJump
					velocity.y -= jumpWall
			anim.play("Jump")
	else:
		if movement_x == 0:
			anim.play("Fall")
			velocity.x = lerp(velocity.x, 0, resistance)
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func nextToWall():
	return nextRight() or nextLeft()

func nextRight():
	return $Right.is_colliding()

func nextLeft():
	return $Left.is_colliding()

func dash():
	if is_on_floor():
		dashable = true
	
	if Input.is_action_pressed("ui_right"):
		dashDirection = Vector2(1,0)
	if Input.is_action_pressed("ui_left"):
		dashDirection = Vector2(-1,0)
	if Input.is_action_just_pressed("dash") and dashable or inAirDash():
		velocity = dashDirection.normalized() * 50000
		dashable = false
		isDash = true
		yield(get_tree(). create_timer(0.2), "timeout")
		isDash = false

func inAirDash():
	return (Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right")) and Input.is_action_just_pressed("dash")
