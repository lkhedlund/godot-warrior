class_name TurnManager
extends Node2D

signal turn_over

var current_turn setget set_current_turn

# Time before the next turn starts
export var ui_cooldown := 0.1
onready var _timer: Timer = $Timer

func _ready() -> void:
	_timer.wait_time = ui_cooldown

func _process(delta) -> void:
	turn()

func turn() -> void:
	yield(current_turn, "action_taken")
	emit_signal("turn_over", current_turn)
	_timer.start()
	
func set_current_turn(unit: Unit) -> void:
	current_turn = unit
