extends Popup

onready var menu = $MenuContainer

func open_menu() -> void:
	get_tree().paused = true
	self.visible = true
	
func close_menu() -> void:
	get_tree().paused = false
	self.visible = false

func _on_CloseButton_pressed():
	close_menu()

func _on_ResetButton_pressed():
	EventBus.emit_signal("reset_game")
