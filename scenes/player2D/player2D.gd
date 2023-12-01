extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

var active: bool = false
var facing_right: bool = false
var spawn_done: bool = false

func add_to_picture(target: Node2D):
	print("adding player to picture " + str(target))
	reparent(target)
	await get_tree().create_timer(0.5).timeout
	PlayerManager.transition_active = false

func set_active(status: bool = true):
	active = status
	animated_sprite.speed_scale = 2

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if not active or not spawn_done:
		move_and_slide()
		return
		
	animated_sprite.speed_scale = 1
		
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * (scale.x / 3)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if velocity.x != 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")
		
	if velocity.x > 0 and !facing_right:
		facing_right = true
		animated_sprite.scale.x *= -1
	if velocity.x < 0 and facing_right:
		facing_right = false
		animated_sprite.scale.x *= -1

	move_and_slide()

func get_drop_position():
	print("getting drop position of player 2d")
	return Vector2(global_position.x + 3, global_position.y + 3)


func _on_animated_sprite_2d_animation_finished():
	if !spawn_done:
		spawn_done = true
		if velocity.x != 0:
			animated_sprite.play("walk")
		else:
			animated_sprite.play("idle")
