class_name Level
extends Node

export(String, MULTILINE) var description
export(String, MULTILINE) var hint
export(String, MULTILINE) var tip
export var high_score := 0

onready var player_unit = $GameBoard/Units/PlayerUnit

func _ready() -> void:
	EventBus.emit_signal("update_player_log", description)
	EventBus.emit_signal("update_player_log", hint, "hint")
