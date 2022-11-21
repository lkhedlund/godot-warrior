extends ModalMenu

onready var player_stats = GameManager.player_stats
onready var extra_logs = $MenuContainer/MenuButtons/ExtraLogsCheckbox
onready var speed_slider = $MenuContainer/MenuButtons/GameSpeed/SpeedSlider

func _ready() -> void:
	extra_logs.pressed = player_stats.extra_logging
	speed_slider.value = player_stats.game_speed

func _on_ResetButton_pressed():
	EventBus.emit_signal("reset_game")

func _on_ExtraLogsCheckbox_toggled(button_pressed: bool) -> void:
	extra_logs.pressed = button_pressed
	player_stats.set_extra_logs(button_pressed)

func _on_SpeedSlider_value_changed(value: float) -> void:
	speed_slider.value = value
	player_stats.set_game_speed(value)
