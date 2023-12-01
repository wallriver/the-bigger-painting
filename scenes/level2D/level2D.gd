extends Node2D
class_name LevelParent2D

const Item2D = preload("res://items/pick_up/item_2d.tscn")

@onready var playerSpawnPosition: Marker2D = %PlayerSpawnPosition
@onready var playerEnterPosition: Marker2D = %PlayerEnterPosition
@onready var player_container: Node2D = %PlayerContainer
@export var player_scale: float = 1.0
var player: CharacterBody2D = null
var active: bool = false
var has_entered_from_3d: bool = false

func add_player(new_player: CharacterBody2D, entered_from_3d: bool = false):
	player = new_player
	if entered_from_3d:
		player = new_player
		player_container.add_child(new_player)
		new_player.global_position = playerSpawnPosition.global_position
		has_entered_from_3d = true
	else:
		player.call_deferred("add_to_picture", player_container)
		new_player.global_position = playerEnterPosition.global_position
		has_entered_from_3d = false
	print("adding player to level " + str(self) + ", player_scale is " + str(player_scale) + ", player.scale: " + str(player.scale.x))
	player.scale = Vector2(player_scale, player_scale)
	
func set_player_scale(new_scale: float):
	player.scale = Vector2(new_scale, new_scale)

func remove_player():
	if player != null:
		player.queue_free()

func set_active(status: bool = true):
	active = status
	if player != null and player.has_method("set_active"):
		player.set_active(status)

func _on_inventory_ui_drop(slot_data) -> Item2D:
	if active:
		var item = Item2D.instantiate()
		item.slot_data = slot_data
		item.position = player.get_drop_position()
		add_child(item)
		return item
	return null
