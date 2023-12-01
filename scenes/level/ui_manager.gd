extends CanvasLayer

@onready var settings_ui = %SettingsScreen
@onready var escape_menu = %EscapeMenu

var active_screen: String = ""

func _ready():
	escape_menu.visible = false
	settings_ui.visible = false
	active_screen = ""
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_player_toggle_menu():
	print("player is toggling the menu - active screen is " + active_screen)
	if active_screen == "":
		active_screen = "escape_menu"
		escape_menu.visible = true
	elif active_screen == "escape_menu":
		active_screen = ""
		escape_menu.visible = false
	elif active_screen == "settings_ui":
		active_screen = ""
		settings_ui.visible = false

	if active_screen != "":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_escape_menu_quit_to_menu():
	print("quitting to menu")
	get_tree().change_scene_to_file("res://scenes/level2D/menu_scenes/start_screen.tscn")

func _on_escape_menu_show_settings():
	print("showing settings")
	active_screen = "settings_ui"
	escape_menu.visible = false
	settings_ui.visible = true


func _on_escape_menu_hide_menu():
	active_screen = ""
	escape_menu.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
