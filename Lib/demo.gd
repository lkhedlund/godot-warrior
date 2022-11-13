extends Node2D

func play_turn(warrior: Unit) -> void:
	if warrior.feel("enemy"):
		warrior.attack()
	else:
		warrior.walk()
