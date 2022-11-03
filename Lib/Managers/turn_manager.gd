class_name TurnManager
extends Node2D

signal turn_over

var _current_turn
# Time before the next turn starts
export var ui_cooldown := 0.1
onready var _timer: Timer = $Timer

func _ready() -> void:
	_timer.wait_time = ui_cooldown

# Controllers the cursor's current position
func turn(value: Vector2) -> void:
	emit_signal("turn_over", _current_turn)
	_timer.start()
