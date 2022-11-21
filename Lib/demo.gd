extends Node2D

var current_health := 0

func play_turn(warrior: Unit) -> void:
	var health = warrior.health
	
	if warrior.feel("enemy"):
		warrior.attack()
	elif warrior.feel("trap"):
		warrior.disarm()
	else:
		if health < current_health:
			warrior.walk()
		elif health <= 15:
			warrior.rest()
		else:
			warrior.walk()
	current_health = health

func ranged_attack(warrior: Unit) -> void:
	for target in warrior.look():
		warrior.shoot(target)
