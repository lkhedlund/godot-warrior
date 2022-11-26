class_name FloatingTextEffect
extends Node2D

signal effect_finished

var damage_text = preload("res://Lib/Effects/damage_text.tscn")

export var duration = 2
export var travel = Vector2(0, -60)
export var spread = 0.25

func display_effect(value, heal=false) -> void:
	var instance = damage_text.instance()
	add_child(instance)
	var show_effect = instance.show_value(str(value), travel, duration, spread, heal)
	yield(show_effect, "completed")
	emit_signal("effect_finished")

func _on_Unit_health_changed(amount: int, type: String) -> void:
	display_effect(amount, type == 'heal')
