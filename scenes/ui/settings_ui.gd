extends Control

@onready var music_active_checkbox: CheckBox = %MusicOnCheckbox
@onready var music_volume_slider: Slider = %MusicVolumeSlider
@onready var sfx_active_checkbox: CheckBox = %SFXOnCheckbox
@onready var sfx_volume_slider: Slider = %SFXVolumeSlider

func _ready():
	music_active_checkbox.set_pressed_no_signal(Music.is_active())
	music_volume_slider.set_value_no_signal(Music.get_volume())
	sfx_active_checkbox.set_pressed_no_signal(GameSettings.sfx_active)
	sfx_volume_slider.set_value_no_signal(GameSettings.sfx_volume)

func _on_music_on_checkbox_toggled(button_pressed):
	Music.set_active(button_pressed)

func _on_music_volume_slider_value_changed(value):
	Music.set_volume(value)

func _on_sfx_on_checkbox_toggled(button_pressed):
	GameSettings.sfx_active = button_pressed

func _on_sfx_volume_slider_value_changed(value):
	GameSettings.sfx_volume = value
