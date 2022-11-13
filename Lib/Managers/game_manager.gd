extends Node

var game
var player_stats

onready var level_manager: LevelManager = $LevelManager

func _ready() -> void:
	EventBus.connect("player_stats_changed", self, "_on_Player_Stats_changed")
	EventBus.connect("reset_game", self, "_on_reset_game")
	initialize_game()
	load_player_stats()
	level_manager.load_level(player_stats.current_level)

func initialize_game() -> void:
	game = get_tree().get_root().get_node('/root/Game')
	EventBus.emit_signal("game_init")

func game_over() -> void:
	print("Game Over")
	get_tree().quit()

func load_player_stats():
	reinitialize_player_stats()
	# Load the player's current stats
	var existing_stats = load("user://player_stats.tres")
	if existing_stats:
		player_stats = existing_stats
		return
	reinitialize_player_stats()
		
func reinitialize_player_stats() -> void:
	var new_player_stats = load("res://Lib/Unit/Stats/player_stats.tres")
	ResourceSaver.save("user://player_stats.tres", new_player_stats)
	player_stats = new_player_stats

# Creates a persistent save on stat changes
func _on_Player_Stats_changed(new_player_stats) -> void:
	ResourceSaver.save("user://player_stats.tres", new_player_stats)

func _on_reset_game() -> void:
	reinitialize_player_stats()
	get_tree().quit()
