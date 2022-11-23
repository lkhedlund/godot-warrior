extends Node2D

var current_health := 0

func play_turn(warrior: Unit) -> void:
	var health = warrior.health
	var targets = warrior.look()

	if warrior.feel("enemy"):
		warrior.attack()
	elif warrior.feel("trap"):
		warrior.disarm()
	else:
		if health < current_health:
			warrior.walk()
		elif health <= 14:
			warrior.rest()
		elif targets:
			ranged_attack(warrior, targets)
		else:
			warrior.walk()
	current_health = health

func ranged_attack(warrior: Unit, targets: Array) -> void:
	if not targets: return

	for target in targets:
		warrior.shoot(target)
