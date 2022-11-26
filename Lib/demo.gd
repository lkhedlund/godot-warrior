extends Node2D

var current_health := 0

func play_turn(warrior: Unit) -> void:
	var health = warrior.health
	var targets = warrior.look()
	
	var next_target = get_next_target(targets)
	print(next_target)

	if warrior.feel("enemy"):
		if next_target.is_enraged:
			warrior.defend()
		else:
			warrior.attack()
	elif warrior.feel("trap"):
		warrior.disarm()
	else:
		if health < current_health:
			warrior.walk()
		elif health <= 14:
			warrior.rest()
		elif next_target:
			warrior.shoot(next_target)
		else:
			warrior.walk()
	current_health = health

func get_next_target(targets: Array):
	return targets[0]
