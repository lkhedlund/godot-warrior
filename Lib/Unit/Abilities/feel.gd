class_name Feel
extends Ability

var board

func perform(unit: Unit, params={}):
	if not params.has("unit_type"):
		return false

	board = unit.game_board
	var next_cell: Vector2 = unit.current_cell + unit.direction
	return feel_space(next_cell, params["unit_type"])

func feel_space(next_cell: Vector2, unit_type: String) -> bool:
	match unit_type:
		"trap":
			return board.is_trap(next_cell)
		_:
			if board.is_occupied(next_cell):
				var adjacent_unit = board.get_unit_at_position(next_cell)
				return adjacent_unit.is_in_group(unit_type)
	return false
