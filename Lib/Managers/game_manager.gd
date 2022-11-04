extends Node

var player: Player
var game_board : GameBoard
var player_unit

var current_level := 1

func _ready() -> void:
	EventBus.connect("board_init", self, "_on_GameBoard_init")

func _process(_delta) -> void:
	if not game_board:
		initialize_board()
		return

func initialize_board() -> void:
	game_board = get_tree().get_root().get_node('/root/Game/GameBoard')
	player_unit = game_board.player_unit
	game_board.load_level(current_level)
	initialize_player()
	EventBus.emit_signal("board_init")

func initialize_player() -> void:
	player = get_tree().get_root().get_node('/root/Game/Player')
	if not player:
		return

	EventBus.emit_signal("player_init", player)
