class_name TurnManager
extends Node2D

signal turn_over

enum Turns { PLAYER, ENEMY }
var current_turn = Turns.PLAYER setget set_current_turn
var player

# Time before the next turn starts
export var ui_cooldown := 0.5
onready var _timer: Timer = $Timer

func _ready() -> void:
	_timer.wait_time = ui_cooldown

func turn(unit: Unit) -> void:
	yield(unit, "move_finished")
	emit_signal("turn_over", unit)
	_timer.start()
	
func set_current_turn(value) -> void:
	current_turn = value
