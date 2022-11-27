class_name Space
extends Resource

var current_cell: Vector2
var unit: Unit

func is_empty() -> bool:
	return unit == null
