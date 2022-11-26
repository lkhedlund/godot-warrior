class_name Shoot
extends Attack

func perform(unit: Unit, params={}) -> void:
	damage = params["damage"]
	board = unit.game_board
	# Cannot perform ranged attacks against targets directly next to you
	var next_space = unit.current_cell + unit.direction
	if board.is_occupied(next_space):
		return
	var target_unit = params["target_unit"]
	if target_unit:
		target_unit.take_damage(-damage)
