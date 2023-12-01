extends RigidBody3D

@export var slot_data: SlotData
@onready var sprite_3d: Sprite3D = $Sprite3D

signal pickup_range_entered(Item2D, SlotData)
signal pickup_range_exited(SlotData)

func _ready():
	sprite_3d.texture = slot_data.item_data.texture

func _physics_process(delta: float) -> void:
	sprite_3d.rotate_y(delta)

func _on_pickup_area_body_entered(_body):
	pickup_range_entered.emit(self, slot_data)
	# if body.inventory_data.pick_up_slot_data(slot_data):
		# queue_free()

func _on_pickup_area_body_exited(_body):
	pickup_range_exited.emit(slot_data)
	pass 
