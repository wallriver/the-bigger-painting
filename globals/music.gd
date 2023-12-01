extends Node

@onready var audio_player: AudioStreamPlayer = %MainThemePlayer

func set_volume(value: int):
	print("setting volume to " + str(value))
	audio_player.volume_db = value - 100
	print("new audio player vol: " + str(audio_player.volume_db))

func set_active(active: bool):
	print("setting music to active: " + str(active))
	if active:
		audio_player.play()
	else:
		audio_player.stop()

func get_volume():
	return audio_player.volume_db + 100

func is_active():
	return audio_player.playing
