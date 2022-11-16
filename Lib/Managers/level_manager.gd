class_name LevelManager
extends Node

var current_level: Node2D
export(Array, PackedScene) var levels: Array

func load_level(new_level_index: int) -> void:
	var new_level = get_level_at_index(new_level_index)
	current_level = new_level
	GameManager.game.add_child(new_level)

func load_next_level() -> void:
	var next_level = GameManager.player_stats.current_level + 1
	GameManager.player_stats.current_level = next_level
	clear_previous_level()
	load_level(next_level)

func clear_previous_level() -> void:
	GameManager.game.remove_child(current_level)
	current_level.queue_free()
	
func get_level_at_index(index: int) -> PackedScene:
	return levels[index].instance()

func get_current_level_tip() -> String:
	return current_level.tip
