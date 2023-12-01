extends CharacterBody3D

class_name Player

signal toggle_inventory()
signal toggle_menu()
signal interacts()
signal picture_entered()
signal picture_exited()
signal item_pickup()
 
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var health = 5
var is_in_picture: bool = false
var is_walking: bool = false

var active: bool = true:
	get:
		return active
	set(value):
		active = value
		if active:
			crosshair.show()
		else:
			crosshair.hide()

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
 
@onready var camera: Camera3D = %Camera3D
@onready var interact_ray: RayCast3D = $Camera3D/InteractRay
@onready var crosshair: ColorRect = %Crosshair
@onready var walking_audio: AudioStreamPlayer3D = %WalkingSoundPlayer
@onready var other_audio: AudioStreamPlayer3D = %OtherSoundPlayer

@export var player2D: PackedScene
@export var enter_picture_sound: AudioStream
@export var leave_picture_sound: AudioStream

var interactable: Node3D = null

func _ready() -> void:
	for obj in get_tree().get_nodes_in_group("Interactables"):
		obj.connect("frame_entered", _on_frame_entered)
	GameSettings.sfx_volume_change.connect(_sfx_volume_changed)
	walking_audio.volume_db = GameSettings.sfx_volume - 100
	other_audio.volume_db = GameSettings.sfx_volume - 80
	
func _on_frame_entered(new_frame: Node3D):
	interactable = new_frame

func _sfx_volume_changed(value: int):
	walking_audio.volume_db = value - 100
	other_audio.volume_db = value - 80
 
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and active:
		rotate_y(-event.relative.x * .005)
		camera.rotate_x(-event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/4, PI/4)
 
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_menu.emit()
	
	if Input.is_action_just_pressed("leave_picture"):
		if is_in_picture:
			print("leave_picture - interactable is " + str(interactable))
			interactable.cancel_interaction()
			active = true
			if interactable.spawnPosition != null:
				global_position = interactable.spawnPosition.global_position		
			camera.current = true
			picture_exited.emit()
			is_in_picture = false
			PlayerManager.transition_active = false
			if GameSettings.sfx_active:
				other_audio.stream = leave_picture_sound
				other_audio.play()
		else:
			print("trying to leave the picture, but there is none")
	
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
	
	if Input.is_action_just_pressed("interact"):
		if active and interactable != null:
			interact()
		else:
			item_pickup.emit()
 
func set_interactable(inter: Node3D):
	interactable = inter

func reset_interactable():
	print("resetting current interactable " + str(interactable) + " to null")
	interactable = null
 
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if !active:
		move_and_slide()
		return
 
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
 
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	var was_walking = is_walking
	if velocity.x != 0 or velocity.y != 0:
		is_walking = true
	else:
		is_walking = false
		
	if is_walking != was_walking:
		if is_walking and GameSettings.sfx_active:
			walking_audio.play()
		else:
			walking_audio.stop()
 
	move_and_slide()
	
func interact() -> void:
	if interactable != null:
		if interactable.has_method("jump_into_picture"):
			interacts.emit()
			picture_entered.emit()
			interactable.jump_into_picture(player2D)
			active = false	
			is_in_picture = true
			if GameSettings.sfx_active:
				other_audio.stream = enter_picture_sound
				other_audio.play()
		elif interactable.has_method("unlock_door"):
			if interactable.is_locked():
				interactable.unlock_door()
			else:
				interactable.go_through_door()
		else:
			print("we cannot interact with " + str(interactable))
	# if interact_ray.is_colliding():
		# interact_ray.get_collider().player_interact()
		
func get_drop_position() -> Vector3:
	# return Vector3(global_position.x, global_position.y + 3, global_position.z)
	var direction = -camera.global_transform.basis.z
	var output = camera.global_position + direction * 4
	output.y = global_position.y
	return output

func heal(value: int) -> void:
	health += value
