class_name Look
extends Ability

var visible_targets: Array

func perform(unit: Unit, _params={}) -> Array:
	var board = unit.game_board
	var visible_cells = board.get_visible_cells(unit)
	for cell in visible_cells:
		if not board.is_occupied(cell): continue
		
		# Remove current unit from list
		var target = board.get_unit_at_position(cell)
		if target == unit: continue

		visible_targets.append(target)
	return visible_targets
