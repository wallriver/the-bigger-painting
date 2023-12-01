extends Node3D

signal player_entered(obj: Node3D, message: String)
signal player_exited()
signal door_unlocked()
signal leave_level()

@export var key_required: String
@onready var padlock = %Padlock
@onready var door_unlock_audio: AudioStreamPlayer3D = %DoorUnlockAudio
@onready var door_open_audio: AudioStreamPlayer3D = %DoorOpenAudio

func _ready():
	if key_required == "":
		padlock.queue_free()
	
	GameSettings.sfx_volume_change.connect(_sfx_volume_changed)
	door_unlock_audio.volume_db = GameSettings.sfx_volume - 100
	door_open_audio.volume_db = GameSettings.sfx_volume - 100
	
func _sfx_volume_changed(value: int):
	door_unlock_audio.volume_db = value - 100
	door_open_audio.volume_db = value - 100

func _on_area_3d_body_entered(_body):
	print("exit area entered body of " + str(_body))
	if key_required == "":
		player_entered.emit(self, "Press E to go to the next room")
	else:
		if PlayerManager.has_item(key_required):
			player_entered.emit(self, "Press E to unlock")
		else:
			player_entered.emit(self, "You need a key for this door")

func _on_area_3d_body_exited(_body):
	player_exited.emit()

func unlock_door():
	if PlayerManager.has_item(key_required):
		PlayerManager.remove_item(key_required)
		key_required = ""
		door_unlocked.emit()
		padlock.queue_free()
		if GameSettings.sfx_active:
			door_unlock_audio.play()

func is_locked() -> bool:
	return key_required != ""

func go_through_door():
	if GameSettings.sfx_active:
		door_open_audio.play()
		await get_tree().create_timer(1).timeout
	leave_level.emit()
