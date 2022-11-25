extends ModalMenu

signal credits_opened

onready var player_stats = GameManager.player_stats
onready var extra_logs = $MenuContainer/MenuButtons/ExtraLogsCheckbox

func _ready() -> void:
	extra_logs.pressed = player_stats.extra_logging

func _on_ResetButton_pressed():
	EventBus.emit_signal("reset_game")

func _on_ExtraLogsCheckbox_toggled(button_pressed: bool) -> void:
	extra_logs.pressed = button_pressed
	player_stats.set_extra_logs(button_pressed)

func _on_CreditsButton_pressed():
	close_menu()
	emit_signal("credits_opened")
