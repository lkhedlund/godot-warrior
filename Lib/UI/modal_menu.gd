class_name ModalMenu
extends Popup

func open_menu() -> void:
	get_tree().paused = true
	self.visible = true
	
func close_menu() -> void:
	get_tree().paused = false
	self.visible = false

func _on_CloseButton_pressed():
	close_menu()
