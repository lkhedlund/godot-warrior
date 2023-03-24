class_name Level
extends Node

@export_multiline var description
@export_multiline var hint
@export_multiline var tip
@export var high_score := 0

@onready var player_unit = $GameBoard/Units/PlayerUnit

func _ready() -> void:
	EventBus.emit_signal("update_player_log", description)
	EventBus.emit_signal("update_player_log", hint, "hint")
