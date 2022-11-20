extends Node2D

var current_health := 0

func play_turn(warrior: Unit) -> void:
	var health = warrior.health
	var targets = warrior.look()
	
	if warrior.feel("enemy"):
		warrior.attack()
	elif warrior.feel("trap"):
		if targets:
			for target in targets:
				warrior.shoot(target)
	else:
		if health < current_health:
			warrior.walk()
		elif health <= 15:
			warrior.rest()
		else:
			warrior.walk()
	current_health = health
