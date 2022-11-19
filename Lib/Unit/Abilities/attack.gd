class_name Attack
extends Ability

var board
var damage

func perform(unit: Unit, params={}) -> void:
	damage = params["damage"]
	board = unit.game_board
	var next_cell: Vector2 = unit.current_cell + unit.direction
	attack_unit_at_target(next_cell)

func attack_unit_at_target(cell: Vector2) -> void:
	if board.is_occupied(cell):
		var target_unit = board.get_unit_at_position(cell)
		if target_unit:
			target_unit.take_damage(-damage)
