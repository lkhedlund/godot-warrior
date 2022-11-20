class_name Exit
extends Interactable

func _ready():
	initialize()
	EventBus.connect("exit_level", self, "_on_Exit_level")

func _on_Exit_level() -> void:
	GameManager.level_manager.load_next_level()
