class_name Feel
extends Ability

func perform(unit: Unit, params={}):
	var board = unit.game_board
	var next_cell: Vector2 = unit.current_cell + unit.direction

	if board.is_occupied(next_cell):
		var adjacent_unit = board.get_unit_at_position(next_cell)
		if params.has("unit_type"):
			return adjacent_unit.is_in_group(params["unit_type"])
		# If unit type is not provided, perform action anyways
		return true
	return false
