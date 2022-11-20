class_name Shoot
extends Attack

func perform(unit: Unit, params={}) -> void:
	damage = params["damage"]
	board = unit.game_board
	var target_unit = params["target_unit"]
	if target_unit:
		target_unit.take_damage(-damage)
