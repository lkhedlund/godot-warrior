class_name TurnManager
extends Node

var current_round := 1
var current_turn: Unit
var turn_queue := []

var _turn_cooldown

onready var _timer: Timer = $Timer

func _ready() -> void:
	EventBus.connect("play_button_pressed", self, "_on_Play_Button_pressed")
	EventBus.connect("exit_level", self, "_on_Exit_level")
	_turn_cooldown = GameManager.game_speed

func start_round() -> void:
	if turn_queue.empty(): return

	var i = 0
	for unit in turn_queue:
		unit.reset()
		if is_next_in_queue(i):
			yield(advance_turn(unit), "completed")
		i += 1
	# Advance to the next round
	advance_round()
	
func advance_turn(unit: Unit) -> void:
	_timer.start(_turn_cooldown)
	yield(_timer, "timeout")
	unit.take_turn()
	
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
	
func is_next_in_queue(index: int) -> bool:
	# Only take turns for the first two units in the 
	# queue, i.e. the player and first enemy.
	return index == 0 or index == 1

# SIGNALS
func _on_Play_Button_pressed() -> void:
	start_round()
	
func _on_Exit_level() -> void:
	reset_rounds()
