extends Node2D

var damage_text = preload("res://Lib/Effects/damage_text.tscn")

export var travel = Vector2(0, -80)
export var duration = 2

func display_effect(value, heal=false) -> void:
	var instance = damage_text.instance()
	add_child(instance)
	instance.show_value(str(value), travel, duration, heal)

func _on_Unit_health_changed(amount: int, type: String) -> void:
	display_effect(amount, type == 'heal')
