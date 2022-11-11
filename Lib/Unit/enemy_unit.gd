class_name EnemyUnit
extends Unit

func take_turn() -> void:
	.take_turn() # super
	
	if feel("player"):
		attack()
