extends Node2D

func play_turn(warrior: Unit) -> void:
	var health = warrior.health()
	if warrior.feel("enemy"):
		warrior.attack()
	else:
		warrior.walk()
