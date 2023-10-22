extends CharacterBody2D

var movingDirection # right, left, stop
var isJumped = false

var runSpeed = 550
var gravityAcceleration = 1400
var jumpAcceleration = 40000

@onready var animation = get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	movingDirection = 'right'


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()
	move_player(delta)
	play_animation()
	
	move_and_slide()

func play_animation():
	if (velocity.y < 0):
		animation.play('jump')
	elif (velocity.y > 0):
		animation.play('fall')
	else:
		if (velocity.x > 0):
			animation.play('run')
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.speed_scale = 1.5
		elif (velocity.x < 0):
			animation.play('run')
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.speed_scale = 1.5
		else:
			animation.play('idle')
			$AnimatedSprite2D.speed_scale = 1
	
	flip_animation()
	

func get_input():
	if Input.is_action_pressed('ui_right'):
		movingDirection = 'right'
	elif Input.is_action_pressed('ui_left'):
		movingDirection = 'left'
	else:
		movingDirection = 'stop'
	
	if is_on_floor() and Input.is_action_pressed("player_jump"):
		isJumped = true
	
func flip_animation():
	if movingDirection == 'left':
		$AnimatedSprite2D.set_flip_h(true)
	elif movingDirection == 'right':
		$AnimatedSprite2D.set_flip_h(false)
		
func move_player(delta):
	if (!is_on_floor()):
		velocity.y += gravityAcceleration * delta
	
	if (movingDirection == 'right'):
		velocity.x = runSpeed
	elif (movingDirection == 'left'):
		velocity.x = -runSpeed	
	else:
		velocity.x = 0
		
	if (isJumped):
		velocity.y -= jumpAcceleration * delta
		isJumped = false
