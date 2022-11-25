class_name LevelManager
extends Node

signal level_loaded

var current_level: Node2D
export(Array, PackedScene) var levels: Array

func load_level(new_level_index: int) -> void:
	
	var new_level = get_level_at_index(new_level_index)
	current_level = new_level
	GameManager.game.add_child(new_level)
	emit_signal("level_loaded")

func load_next_level() -> void:
	var next_level_index = GameManager.player_stats.current_level + 1
	if not range(levels.size()).has(next_level_index):
		var text = "Congratulations! Thanks to your exceptional programming skills the warrior has escaped with their life. Keep challenging yourself to learn more, and thanks for playing!"
		EventBus.emit_signal("game_over", "win", text)
		return
	GameManager.player_stats.current_level = next_level_index
	clear_previous_level()
	load_level(next_level_index)

func clear_previous_level() -> void:
	GameManager.game.remove_child(current_level)
	current_level.queue_free()
	
func get_level_at_index(index: int) -> PackedScene:
	return levels[index].instance()

func get_current_level_tip() -> String:
	return current_level.tip
