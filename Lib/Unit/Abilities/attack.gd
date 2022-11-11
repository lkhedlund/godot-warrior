class_name Attack
extends Ability

export var damage := 10

func perform(unit: Unit, _params={}) -> void:
	var board = unit.game_board
	var next_cell: Vector2 = unit.current_cell + unit.direction
	if board.is_occupied(next_cell):
		var adjacent_unit = board.get_unit_at_position(next_cell)
		if adjacent_unit:
			do_damage(adjacent_unit)

func do_damage(unit: Unit) -> void:
	unit.set_health(damage)
	var new_line = "%s took %s damage" % [unit.name, str(damage)]
	EventBus.emit_signal("update_player_log", new_line)
