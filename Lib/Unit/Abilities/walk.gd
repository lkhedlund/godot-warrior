class_name Walk
extends Ability

func perform(unit: Unit, params={}):
	var board = unit.game_board
	var next_cell = unit.current_cell + unit.direction

	if not board.is_occupied(next_cell):
		board.move_current_unit(next_cell)
		
	if board.is_exit(next_cell) and unit.is_in_group("player"):
		board.move_current_unit(next_cell)
		EventBus.emit_signal("exit_level")
