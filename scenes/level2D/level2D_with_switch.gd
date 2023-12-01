extends LevelParent2D
class_name LevelWithSwitch

@export var next_picture: PictureFrame
@export var previous_picture: PictureFrame

var next_picture_coming: bool = false

func _on_picture_switch_zone_player_entered(zone, is_next: bool):
	if PlayerManager.transition_active:
		print("transition is already active")
		return
	next_picture_coming = is_next
	print("player entered switch zone " + str(zone) + " in level " + str(self) + " - transition active: " + str(PlayerManager.transition_active))
	if !active or PlayerManager.transition_active:
		print("ignoring switch zone. active: " + str(active) + ", PlayerManager: " + str(PlayerManager.transition_active))
		return
	
	Tutorial.show_message("escape", "Press Q to leave the picture")
	
	TransitionLayer.connect("transition_halfway", _on_transition_halfway)
	TransitionLayer.show_transition(self)
	set_active(false)
	
func _on_transition_halfway():
	TransitionLayer.disconnect("transition_halfway", _on_transition_halfway)
	
	var next_scale = player.scale.x
	if has_entered_from_3d:
		next_scale = player_scale
		
	if next_picture_coming or previous_picture == null:
		next_picture.transition_to_level(player, next_scale)
	else:
		previous_picture.transition_to_level(player, next_scale)
