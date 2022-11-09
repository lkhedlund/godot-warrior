class_name TurnManager
extends Node

signal turn_over

var current_turn : Unit
var current_round := 1
var turn_queue := []

export var _turn_cooldown := 1.0

onready var _timer: Timer = $Timer

func _ready() -> void:
	EventBus.connect("play_button_pressed", self, "_on_Play_Button_pressed")
	EventBus.connect("exit_level", self, "_on_Exit_level")

func start_round() -> void:
	if turn_queue.empty(): return

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
	if turn_queue.has(unit): return

	turn_queue.append(unit)
	
func remove_turn_from_queue(unit: Unit) -> void:
	turn_queue.erase(unit)

func advance_round() -> void:
	if turn_queue.empty(): return
	current_round += 1
	start_round()
	
func reset_rounds() -> void:
	# Empty turn queue
	turn_queue.clear()
	current_round = 0
	
# SIGNALS
func _on_Play_Button_pressed() -> void:
	start_round()
	
func _on_Exit_level() -> void:
	reset_rounds()
