class_name Attack
extends Ability

export var cooldown := 0

func perform(unit: Unit, params={}) -> void:
	var damage = params["damage"]
	var board = unit.game_board
	var next_cell: Vector2 = unit.current_cell + unit.direction
	if board.is_occupied(next_cell):
		var adjacent_unit = board.get_unit_at_position(next_cell)
		if adjacent_unit:
			adjacent_unit.take_damage(-damage)
