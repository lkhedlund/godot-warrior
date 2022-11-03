class_name Player
extends Node

func play_turn(warrior: Unit) -> void:
	warrior.walk("east")
