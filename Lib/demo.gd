extends Node2D

var current_health

func play_turn(warrior: Unit) -> void:
	var health = warrior.health
	
	if warrior.feel("enemy"):
		warrior.attack()
	else:
		if current_health:
			if health <= current_health:
				warrior.walk()
		elif health <= 15:
			warrior.rest()
		else:
			warrior.walk()
	
	current_health = health
