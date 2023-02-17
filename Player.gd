extends CharacterBody2D


@export var  SPEED = 150.0
@export var JUMP_VELOCITY = -130.0
@export var MIN_JUMP_VELOCITY = -70
@export var ACCELERATION = 15
@export var FRICTION = 15
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animatedSprite = $AnimatedSprite2D

func _ready():
	animatedSprite.frames = load("res://PlayerBlueSkin.tres")

func _physics_process(delta):
	
	# Add the gravity.
	apply_gravity()
	
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	# Handle walking and friction
	if input.x == 0:
		animatedSprite.animation = "idle"
		apply_friction()
	else:
		animatedSprite.animation = "walk"
		apply_acceleration(input.x)
		
		# Flip sprite based on direction of movement
		if input.x > 0:
			animatedSprite.flip_h = true
		elif input.x < 0:
			animatedSprite.flip_h = false
	
	# Handle jump
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_VELOCITY
	else:
		animatedSprite.animation = "jump"
		if Input.is_action_just_released("ui_up") and velocity.y < MIN_JUMP_VELOCITY:
			velocity.y = MIN_JUMP_VELOCITY
		
		# Apply fast fall gravity
		if velocity.y > 0:
			velocity.y += 4
	
	var was_in_air = not is_on_floor()
	move_and_slide()
	var just_landed = is_on_floor() and was_in_air
	if just_landed:
		animatedSprite.animation = "walk"
		animatedSprite.frame = 1
		
	animatedSprite.play()
	
func apply_gravity():
	if not is_on_floor():
		velocity.y += 4
	
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, SPEED * amount, ACCELERATION)
