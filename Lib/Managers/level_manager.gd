class_name LevelManager
extends Node

var current_level := 1

func _ready() -> void:
	pass

func load_level(new_level_index: int) -> void:
	var levels = get_tree().get_nodes_in_group("Level")
	for level in levels:
		level.queue_free()

	var new_level_path = "res://Lib/Levels/Level_%02d.tscn" % new_level_index
	if ResourceLoader.exists(new_level_path):
		var new_level = load(new_level_path).instance()
		GameManager.game.add_child(new_level)
	else:
		GameManager.game_over()

func load_next_level() -> void:
	var next_level = current_level + 1
	load_level(next_level)
