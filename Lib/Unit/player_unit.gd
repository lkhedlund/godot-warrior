class_name PlayerUnit
extends Unit

var player

func _ready() -> void:
	player = get_tree().get_root().get_node('/root/Game/Player')

func take_turn() -> void:
	.take_turn() # super
	player.play_turn(self)

func walk() -> void:
	var next_cell = current_cell + Vector2.RIGHT
	if game_board.is_exit(next_cell):
		game_board.move_current_unit(next_cell)
		EventBus.emit_signal("exit_level")
		
	if not game_board.is_occupied(next_cell):
		game_board.move_current_unit(next_cell)
