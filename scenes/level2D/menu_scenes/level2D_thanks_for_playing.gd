extends Node2D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_back_to_start_button_pressed():
	SceneLoader.load_scene("res://scenes/level2D/menu_scenes/start_screen.tscn")
