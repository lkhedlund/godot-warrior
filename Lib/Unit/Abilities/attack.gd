class_name Attack
extends Ability

export var damage := 5

func perform(unit: Unit, _params={}) -> void:
	var board = unit.game_board
	var next_cell: Vector2 = unit.current_cell + unit.direction
	if board.is_occupied(next_cell):
		var adjacent_unit = board.get_unit_at_position(next_cell)
		if adjacent_unit:
			unit.take_damage(-damage)
