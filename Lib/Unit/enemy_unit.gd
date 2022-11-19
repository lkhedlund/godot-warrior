tool
class_name EnemyUnit
extends Unit

func take_turn() -> void:
	.take_turn() # super

	var targets = self.look()	
	if targets:
		for target in targets:
			if target.is_in_group("player"):
				shoot(target)
	
	if self.feel("player"):
		attack()
