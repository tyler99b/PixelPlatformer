extends CharacterBody2D


@export var  SPEED = 150.0
@export var JUMP_VELOCITY = -130.0
@export var MIN_JUMP_VELOCITY = -70
@export var ACCELERATION = 15
@export var FRICTION = 15
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	apply_gravity()
	
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input.x == 0:
		apply_friction()
	else:
		apply_acceleration(input.x)
	# Handle Jump.
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_just_released("ui_up") and velocity.y < MIN_JUMP_VELOCITY:
			velocity.y = MIN_JUMP_VELOCITY
		
		if velocity.y > 0:
			velocity.y += 4
			

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
	#	velocity.x = direction * SPEED
		$AnimatedSprite2D.flip_h = velocity.x > 0
	#else:	
	#	velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "walk"
		
	else:
		$AnimatedSprite2D.animation = "idle"
		
	
	$AnimatedSprite2D.play()

	move_and_slide()

func apply_gravity():
	if not is_on_floor():
		velocity.y += 4
	
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, SPEED * amount, ACCELERATION)
