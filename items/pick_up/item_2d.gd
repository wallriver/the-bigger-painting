extends RigidBody2D

class_name Item2D

@export var slot_data: SlotData
@export var rotates: bool = true
@export var pickup_sound: AudioStream
@onready var sprite: Sprite2D = $Sprite2D

signal pickup_range_entered(Item2D, SlotData)
signal pickup_range_exited(SlotData)

func _ready():
	sprite.texture = slot_data.item_data.texture

func _physics_process(delta: float) -> void:
	if rotates:
		sprite.rotate(delta)

func _on_pickup_area_body_entered(_body):
	pickup_range_entered.emit(self, slot_data)
	# if body.inventory_data.pick_up_slot_data(slot_data):
		# queue_free()

func _on_pickup_area_body_exited(_body):
	pickup_range_exited.emit(slot_data)
	pass 
