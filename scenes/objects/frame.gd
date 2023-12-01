extends Node3D

class_name PictureFrame

signal area_entered(Node3D)
signal area_exited(Node3D)
signal frame_entered(Node3D)

@onready var camera: Camera3D = $Camera3D
@onready var spawnPosition: Marker3D = $SpawnPosition
@export var displayedLevel: LevelParent2D
@export var viewport: SubViewport

func _ready():
	if viewport != null:
		viewport.set_clear_mode(SubViewport.CLEAR_MODE_ONCE)
		
		# Let two frames pass to make sure the vieport is captured.
		await get_tree().process_frame
		await get_tree().process_frame
		
		$Painting.material_override.albedo_texture = viewport.get_texture()

func _process(_delta):
	pass

func _on_area_3d_body_entered(_body):
	area_entered.emit(self)

func _on_area_3d_body_exited(_body):
	area_exited.emit(self)

func jump_into_picture(player2D: PackedScene):
	camera.current = true
	var p2 = player2D.instantiate()
	displayedLevel.add_player(p2, true)
	displayedLevel.set_active(true)
	
func transition_to_level(player: CharacterBody2D, oldScale: float):
	camera.current = true
	displayedLevel.add_player(player)
	displayedLevel.set_player_scale(oldScale)
	displayedLevel.set_active(true)
	frame_entered.emit(self)

func cancel_interaction():
	displayedLevel.remove_player()
	displayedLevel.set_active(false)
