class_name TurnManager
extends Node

signal turn_over

var current_turn : Unit
var current_round := 1
var turn_queue := []

export var _turn_cooldown := 1.0

onready var _timer: Timer = $Timer

func _ready() -> void:
	EventBus.connect("unit_turns_loaded", self, "_on_Unit_turns_loaded")
	EventBus.connect("exit_level", self, "_on_Exit_level")

func start_round() -> void:
	if turn_queue.empty(): return

	print(turn_queue)
	for unit in turn_queue:
		advance_turn(unit)
	yield(self, "turn_over")
	# Advance to the next round
	advance_round()
	
func advance_turn(unit: Unit) -> void:
	current_turn = unit
	_timer.start(_turn_cooldown)
	yield(_timer, "timeout")
	unit.take_turn()
	emit_signal("turn_over")
	
func add_turn_to_queue(unit: Unit) -> void:
	turn_queue.append(unit)

func advance_round() -> void:
	if turn_queue.empty(): return
	current_round += 1
	print(current_round)
	start_round()

func _on_Unit_turns_loaded() -> void:
	print("New Level")
	start_round()

func _on_Exit_level() -> void:
	print("Exited level")
	# Empty turn queue
	turn_queue.clear()
	print(turn_queue)
