extends Node

var player: Player
var game_board : GameBoard
var player_unit

onready var _turn_manager = $TurnManager

func _process(_delta) -> void:
	if not player:
		initialize_player()
		return

func initialize_player() -> void:
	player = get_tree().get_root().get_node('/root/Game/Player')
	if not player:
		return
	
	game_board = get_tree().get_root().get_node('/root/Game/GameBoard')
	player_unit = game_board.player_unit
	EventBus.emit_signal("player_initialized", player)
