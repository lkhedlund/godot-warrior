extends Node

var game_board : GameBoard
var current_level := 1

func _ready() -> void:
	EventBus.connect("board_init", self, "_on_GameBoard_init")

func _process(_delta) -> void:
	if not game_board:
		initialize_board()
		return

func initialize_board() -> void:
	game_board = get_tree().get_root().get_node('/root/Game/GameBoard')
	game_board.load_level(current_level)
	EventBus.emit_signal("board_init")
