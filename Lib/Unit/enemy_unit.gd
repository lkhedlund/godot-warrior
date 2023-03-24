@tool
class_name EnemyUnit
extends Unit

var is_enraged := false
@export var ranged_unit := false

func take_turn() -> void:
	super.take_turn() # super

	if ranged_unit:
		ranged_attack()
	else:
		if feel("player"):
			attack()
		else:
			walk()
	emit_signal("turn_over")

func ranged_attack() -> void:
	var targets = look()	
	if not targets: return
		
	for target in targets:
		if target.is_in_group("player"):
			shoot(target)
