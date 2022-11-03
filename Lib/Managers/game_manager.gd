extends Node

var _player: Player
var _game_board : GameBoard
var _player_unit: Unit

onready var _turn_manager: TurnManager = $TurnManager

func _process(_delta) -> void:
	if not _player:
		initialize_player()
		return

	if not _game_board:
		initialize_game_board()
		return

func initialize_player() -> void:
	_player = get_tree().get_root().get_node('/root/Game/Player')
	if not _player:
		return

func initialize_game_board():
	_game_board = get_tree().get_root().get_node('/root/Game/GameBoard')
	_player_unit = _game_board.player_unit
	if not _game_board:
		return
