class_name TurnManager
extends Node2D

enum Turns { PLAYER, ENEMY }
var current_turn = Turns.PLAYER setget set_current_turn
var current_unit

# Time before the next turn starts
export var cooldown := 0.75
onready var _timer: Timer = $Timer

func _ready() -> void:
	EventBus.connect("player_initialized", self, "_on_Player_initialized")
	EventBus.connect("start_turn", self, '_on_start_turn')
	_timer.wait_time = cooldown

func player_turn() -> void:
	current_unit = GameManager.player_unit
	GameManager.player.play_turn(current_unit)
	yield(current_unit, "move_finished")
	EventBus.emit_signal("end_turn", current_unit)
	_timer.start()

func set_current_turn(value) -> void:
	current_turn = value
	
func _on_Player_initialized(player) -> void:
	player_turn()
	
func _on_Timer_timeout() -> void:
	player_turn()
