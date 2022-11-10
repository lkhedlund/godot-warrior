class_name EnemyUnit
extends Unit

func take_turn() -> void:
	.take_turn() # super
	
	if feel("player"):
		attack()
	

func walk() -> void:
	if not has_ability("walk"): return

	var next_cell = current_cell + direction
	if not game_board.is_occupied(next_cell):
		game_board.move_current_unit(next_cell)

	if game_board.is_exit(next_cell):
		game_board.move_current_unit(next_cell)
		EventBus.emit_signal("exit_level")

func attack() -> void:
	.attack() # super
	EventBus.emit_signal("update_player_log", "")
