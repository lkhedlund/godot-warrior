class_name TurnManager
extends Node

signal round_over

var current_turn
var current_round := 1
var turn_queue := []

export var _turn_cooldown := 1.0

onready var _timer: Timer = $Timer
	
func advance_turn(unit: Unit) -> void:
	_timer.start(_turn_cooldown)
	yield(_timer, "timeout")
	remove_turn_from_queue(unit)
	
func add_turn_to_queue(unit: Unit) -> void:
	turn_queue.append(unit)
	print(turn_queue)
	
func remove_turn_from_queue(unit: Unit) -> void:
	if turn_queue.empty(): return
	turn_queue.erase(unit)
	if turn_queue.empty():
		current_round += 1
		emit_signal("round_over")
