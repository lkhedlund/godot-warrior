extends Control

onready var play_button = $Container/PlayButton

func _ready() -> void:
	EventBus.connect("exit_level", self, "_on_Exit_level")

func _on_PlayButton_pressed():
	play_button.disabled = true
	EventBus.emit_signal("play_button_pressed")

func _on_Exit_level() -> void:
	play_button.disabled = false
