extends Node

signal show_tutorial(msg: String)

var shown_messages = []

func show_message(id: String, msg: String):
	if(shown_messages.has(id)):
		return
	
	shown_messages.push_back(id)
	show_tutorial.emit(msg)
