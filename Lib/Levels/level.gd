class_name Level
extends Node

export(String, MULTILINE) var description
export(String, MULTILINE) var hint
export var score := 0
export(Array, Resource) var new_abilities: Array

onready var player_unit = $GameBoard/Units/PlayerUnit

func _ready() -> void:
	EventBus.emit_signal("update_player_log", description)
	EventBus.emit_signal("update_player_log", hint, "hint")
	set_new_abilities()

func set_new_abilities() -> void:
	if new_abilities.empty(): return

	for ability in new_abilities:
		GameManager.player_stats.set_ability(ability)
		var ability_text = "Gained new ability: %s" % ability.name.capitalize()
		EventBus.emit_signal("ability_gained", ability)
