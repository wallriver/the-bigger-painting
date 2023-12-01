extends Control
class_name InventoryInterface

signal drop_slot_data(slot_data: SlotData)
signal force_close

@onready var player_inventory: PanelContainer = $PlayerInventory
@onready var grabbed_slot: PanelContainer = $GrabbedSlot
var grabbed_slot_data: SlotData

func _ready():
	grabbed_slot.visible = false
	player_inventory.visible = false

func _physics_process(_delta):
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5,5)

func connect_inventory(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	
func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	print("on inventory interact in the level: " + str(index))
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]: # if we have no grabbed slot data and we are clicking on the slot
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		[_, MOUSE_BUTTON_LEFT]: 
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
		[null, MOUSE_BUTTON_RIGHT]: 
			# use an item
			inventory_data.use_slot_data(index)
		[_, MOUSE_BUTTON_RIGHT]: 
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)
	
	update_grabbed_slot()

func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.is_pressed() and grabbed_slot_data:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				drop_slot_data.emit(grabbed_slot_data)
				grabbed_slot_data = null
			MOUSE_BUTTON_RIGHT:
				drop_slot_data.emit(grabbed_slot_data.create_single_slot_data())
				if grabbed_slot_data.quantity < 1:
					grabbed_slot_data = null		
		update_grabbed_slot()

func _on_visibility_changed():
	if not visible and grabbed_slot_data:
		drop_slot_data.emit(grabbed_slot_data)
		grabbed_slot_data = null
		update_grabbed_slot()
