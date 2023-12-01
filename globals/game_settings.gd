extends Node

signal sfx_volume_change(value: int)
signal sfx_active_change(active: bool)

var sfx_volume: int = 70:
	set(value):
		sfx_volume = value
		sfx_volume_change.emit(sfx_volume)
		print("setting sfx volume: " + str(sfx_volume))
		
var sfx_active: bool = true:
	set(value):
		sfx_active = value
		sfx_active_change.emit(sfx_active)
		print("setting sfx active: " + str(sfx_active))
