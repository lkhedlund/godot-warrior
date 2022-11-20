class_name Trap
extends Interactable

func _on_unit_dead():
	self.queue_free()
