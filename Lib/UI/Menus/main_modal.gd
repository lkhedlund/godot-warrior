extends ModalMenu

onready var extra_logs = $MenuContainer/MenuButtons/ExtraLogsCheckbox
onready var debug_checkbox = $MenuContainer/MenuButtons/DebugCheckbox

func _ready() -> void:
	debug_checkbox.pressed = GameManager.debug_mode
	extra_logs = GameManager.player_stats.extra_logging

func _on_ResetButton_pressed():
	EventBus.emit_signal("reset_game")

func _on_ExtraLogsCheckbox_toggled(button_pressed: bool) -> void:
	GameManager.player_stats.set_extra_logs(button_pressed)

func _on_DebugCheckbox_toggled(button_pressed: bool) -> void:
	GameManager.debug_mode = button_pressed
