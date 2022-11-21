class_name Disarm
extends Ability

func perform(unit: Unit, _params={}) -> void:
	var board = unit.game_board
	var next_cell: Vector2 = unit.current_cell + unit.direction
	if board.is_trap(next_cell):
		EventBus.emit_signal("trap_disarmed", next_cell)
