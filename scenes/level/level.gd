extends Node3D

class_name LevelParent

const Item3D = preload("res://items/pick_up/Item3D.tscn")

@export var next_level: PackedScene

@onready var player: Player = $Player
@onready var toast_panel: Panel = %ToastPanel
@onready var toast_label: Label = %ToastLabel
@onready var player_inventory_interface: InventoryUI = %PlayerInventory
@onready var grabbed_slot: PanelContainer = %GrabbedSlot
@onready var inventory_interface: InventoryInterface = %InventoryUI
@onready var pickup_sound_player: AudioStreamPlayer = %PickupSoundPlayer
@onready var ui = %UI

var player_in_picture: bool = false
var pickup_item: SlotData = null
var pickup_item_in_scene = null # a reference to the Item2D or Item3D in the scene (needs to be removed when the item is picked up)

func _ready():
	player_inventory_interface.visible = true
	Tutorial.connect("show_tutorial", _on_show_tutorial);
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	for obj in get_tree().get_nodes_in_group("Interactables"):
		obj.connect("area_entered", _on_interactable_area_entered)
		obj.connect("area_exited", _on_interactable_area_exited)
	
	for obj in get_tree().get_nodes_in_group("Exit"):
		obj.connect("player_entered", _on_exit_player_entered)
		obj.connect("player_exited", _on_exit_player_exited)
		obj.connect("door_unlocked", _on_exit_unlocked)
		obj.connect("leave_level", _on_exit_leave_level)
		
	for obj in get_tree().get_nodes_in_group("Item"):
		obj.connect("pickup_range_entered", _on_item_pickup_range_entered)
		obj.connect("pickup_range_exited", _on_item_pickup_range_exited)
	
	inventory_interface.connect_inventory(PlayerManager.inventory_data)
	player_inventory_interface.set_inventory_data(PlayerManager.inventory_data)
	
	await get_tree().process_frame
	hide_toast()
	
func _on_item_pickup_range_entered(item_in_scene: Node, slot_data: SlotData):
	show_toast("Press E to pickup " + slot_data.item_data.name)
	pickup_item = slot_data
	pickup_item_in_scene = item_in_scene

func _on_item_pickup_range_exited(_slot_data: SlotData):
	hide_toast()
	pickup_item = null
	pickup_item_in_scene = null

func _on_player_toggles_inventory():
	return
#	print("player toggles inventory")
#	player_inventory_interface.visible = not player_inventory_interface.visible
#	if player_inventory_interface.visible:
#		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
#	else:
#		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
func _on_show_tutorial(msg: String):
	show_toast(msg)

func _on_player_interacts():
	hide_toast()
	
func _on_exit_player_entered(obj: Node3D, message: String):
	show_toast(message)
	player.set_interactable(obj)
	
func _on_exit_player_exited():
	hide_toast()
	player.reset_interactable()
	
func _on_exit_unlocked():
	show_toast("Press E to go to the next room")
	
func _on_exit_leave_level():
	SceneLoader.load_scene(next_level.resource_path)
	
func _on_interactable_area_entered(obj):
	player.set_interactable(obj)
	show_toast("Press E to interact")

func _on_interactable_area_exited(_obj):
	player.reset_interactable()
	hide_toast()

func show_toast(text: String, time: int = 0):
	toast_panel.show()
	toast_label.text = text
	if time > 0:
		await get_tree().create_timer(time).timeout
		toast_panel.hide()

func hide_toast():
	toast_panel.hide()

func _on_inventory_ui_drop(slot_data):
	if not player_in_picture:
		var item = Item3D.instantiate()
		item.slot_data = slot_data
		item.position = player.get_drop_position()
		add_child(item)
		item.connect("pickup_range_entered", _on_item_pickup_range_entered)
		item.connect("pickup_range_exited", _on_item_pickup_range_exited)
	else:
		print("do nothing in 3D, player is in the picture")
		for level in get_tree().get_nodes_in_group("Level2D"):
			var item = level._on_inventory_ui_drop(slot_data)
			if item != null:
				item.connect("pickup_range_entered", _on_item_pickup_range_entered)
				item.connect("pickup_range_exited", _on_item_pickup_range_exited)

func _on_player_picture_entered():
	player_in_picture = true

func _on_player_picture_exited():
	player_in_picture = false

func _on_player_item_pickup():
	if pickup_item != null:
		if pickup_item_in_scene.pickup_sound != null and GameSettings.sfx_active:
			pickup_sound_player.stream = pickup_item_in_scene.pickup_sound
			pickup_sound_player.play()
		PlayerManager.inventory_data.pick_up_slot_data(pickup_item)
		pickup_item = null
		pickup_item_in_scene.queue_free()
	else:
		print("no item")
