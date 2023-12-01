extends StaticBody2D

@export var is_next: bool = true
signal player_entered_switch_zone(zone: StaticBody2D, is_next: bool)

func _on_area_2d_body_entered(_body):
	player_entered_switch_zone.emit(self, is_next)
