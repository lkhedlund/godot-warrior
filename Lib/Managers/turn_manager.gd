class_name TurnManager
extends Node

signal turn_over
signal round_over

var current_turn : Unit
var current_round := 1
var turn_queue := []

export var _turn_cooldown := 1.0

onready var _timer: Timer = $Timer

func _ready() -> void:
	EventBus.connect("unit_turns_loaded", self, "_on_Unit_turns_loaded")
	self.connect("round_over", self, "_on_round_over")

func start_round() -> void:
	if turn_queue.empty(): return

	for unit in turn_queue:
		advance_turn(unit)
		yield(self, "turn_over")

	# Advance to the next round
	advance_round()
	yield(self, "round_over")
	
func advance_turn(unit: Unit) -> void:
	current_turn = unit
	_timer.start(_turn_cooldown)
	yield(_timer, "timeout")
	unit.take_turn()
	emit_signal("turn_over")
	
func add_turn_to_queue(unit: Unit) -> void:
	if turn_queue.has(unit): return

	turn_queue.append(unit)

func advance_round() -> void:
	if turn_queue.empty(): return
	current_round += 1
	emit_signal("round_over")

func _on_Unit_turns_loaded() -> void:
	print("start_new_level")
	start_round()

func _on_round_over() -> void:
	start_round()

func clear_turn_queue() -> void:
	# Empty turn queue
	turn_queue.clear()
