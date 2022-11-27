class_name Look
extends Ability

var space_res = preload("res://Lib/Board/space.gd")

func perform(unit: Unit, _params={}) -> Array:
	var board = unit.game_board
	var visible_cells = board.get_visible_cells(unit)
	var spaces := []
	for cell in visible_cells:
		var space = space_res.new()
		space.current_cell = cell
		if board.is_occupied(cell):
			space.unit = board.get_unit_at_position(cell)
		spaces.append(space)
	return spaces
