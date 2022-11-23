tool
class_name EnemyUnit
extends Unit

export var ranged_unit := false

func take_turn() -> void:
	.take_turn() # super

	if ranged_unit:
		var targets = look()	
		if not targets: return
		
		for target in targets:
			if target.is_in_group("player"):
				shoot(target)
	else:
		if feel("player"):
			attack()
