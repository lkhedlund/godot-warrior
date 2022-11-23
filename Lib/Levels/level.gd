class_name Level
extends Node

export(String, MULTILINE) var description
export(String, MULTILINE) var hint
export(String, MULTILINE) var tip
export var score := 0
export(Array, Resource) var new_abilities: Array

onready var player_unit = $GameBoard/Units/PlayerUnit

func _ready() -> void:
	EventBus.emit_signal("update_player_log", description)
	EventBus.emit_signal("update_player_log", hint, "hint")
	EventBus.emit_signal("new_abilities_gained", new_abilities)
