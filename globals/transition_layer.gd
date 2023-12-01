extends CanvasLayer

signal transition_halfway
@onready var animation_player = $AnimationPlayer

func show_transition(who: Node):
	PlayerManager.transition_active = true
	print("transition fading to black called by " + str(who))
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	print("transition fading to transparent again")
	transition_halfway.emit()
	animation_player.play("reveal")
