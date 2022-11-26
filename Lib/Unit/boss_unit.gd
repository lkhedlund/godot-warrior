tool
class_name BossUnit
extends Unit

var is_enraged := true
var cooldown := 0

func take_turn() -> void:
	.take_turn() # super

	if cooldown > 0:
		cooldown -= 1
		if cooldown == 0:
			is_enraged = true
		emit_signal("turn_over")
		return

	if feel("player"):
		for _i in range(action_points):
			yield(get_tree().create_timer(0.2), "timeout")
			attack()
		
		cooldown = 3
		is_enraged = false
	else:
		walk()

	emit_signal("turn_over")
