extends Node2D

func play_turn(warrior: Unit) -> void:
	var health = warrior.health
	
	if warrior.feel("enemy"):
		warrior.attack()
	else:
		if health < 15:
			warrior.rest()
		warrior.walk()
