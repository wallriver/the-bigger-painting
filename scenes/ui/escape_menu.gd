extends Control

signal show_settings()
signal quit_to_menu()
signal hide_menu()

func _on_settings_button_pressed():
	show_settings.emit()
	hide()

func _on_quit_to_menu_button_pressed():
	quit_to_menu.emit()
	get_tree().change_scene_to_file("res://scenes/level2D/menu_scenes/start_screen.tscn")

func _on_close_menu_button_pressed():
	hide_menu.emit()
