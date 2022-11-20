extends ModalMenu

func _on_ResetButton_pressed():
	EventBus.emit_signal("reset_game")

func _on_ExtraLogsCheckbox_toggled(button_pressed: bool) -> void:
	GameManager.player_stats.set_extra_logs(button_pressed)
