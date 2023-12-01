extends Control

@onready var progress_bar = %ProgressBar
@onready var message_label: Label = %MessageText

func show_message(text: String):
	message_label.text = text
