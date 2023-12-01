extends Node2D

@export var first_level: PackedScene

var loading: bool = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_start_game_button_pressed():
	loading = true
	SceneLoader.load_scene(first_level.resource_path)
