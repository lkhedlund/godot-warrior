tool
class_name BossUnit
extends Unit

var is_enraged := true
var cooldown := 0

func take_turn() -> void:
	.take_turn() # super

	if feel("player"):
		if not in_cooldown():
			is_enraged = true

			for _i in range(action_points):
				yield(get_tree().create_timer(0.2), "timeout")
				attack()
	else:
		walk()

func in_cooldown() -> bool:
	return cooldown != 0
