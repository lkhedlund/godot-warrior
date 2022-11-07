extends Control

func _on_PlayButton_pressed():
	EventBus.emit_signal("play_button_pressed")
