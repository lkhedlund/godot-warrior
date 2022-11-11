class_name LevelManager
extends Node

func load_level(new_level_index: int) -> void:
	clear_levels()

	var new_level_path = "res://Lib/Levels/Level_%02d.tscn" % new_level_index
	if ResourceLoader.exists(new_level_path):
		var new_level = load(new_level_path).instance()
		GameManager.game.add_child(new_level)
	else:
		GameManager.game_over()

func load_next_level() -> void:
	var next_level = GameManager.player_stats.current_level + 1
	GameManager.player_stats.current_level = next_level
	load_level(next_level)

func clear_levels() -> void:
	# remove existing levels
	for level in get_tree().get_nodes_in_group("Level"):
		GameManager.game.remove_child(level)
