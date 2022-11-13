extends ModalMenu

func _on_ResetButton_pressed():
	EventBus.emit_signal("reset_game")
