extends Node

var player

@export var inventory_data: InventoryData
@export var transition_active: bool = false:
	set(value):
		transition_active = value
		print("setting transition_active to " + str(value))

func use_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.use(player)

func get_global_position() -> Vector3:
	return player.global_position

func has_item(id: String) -> bool:
	return inventory_data.has_item(id)

func remove_item(id: String):
	inventory_data.remove_item(id)
