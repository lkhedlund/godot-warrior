extends Node2D

var current_health

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
		if taking_damage(health):
			warrior.walk()
		elif health <= 15:
			warrior.rest()
		else:
			warrior.walk()
	
	current_health = health

func taking_damage(health: int) -> bool:
	if current_health:
		print(health)
		print(current_health)
		return health <= current_health
	return false
