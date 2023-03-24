extends Node

var game
var player_stats

@export var game_speed := 0.5
@export var debug_level := 0
@export var debug_mode := false
@export var god_mode := false

@onready var level_manager: LevelManager = $LevelManager
@onready var music: AudioStreamPlayer = $GameMusic

func _ready() -> void:
	EventBus.connect("player_stats_changed",Callable(self,"_on_Player_Stats_changed"))
	EventBus.connect("reset_game",Callable(self,"_on_reset_game"))
	EventBus.connect("music_toggled",Callable(self,"_on_music_toggle"))
	initialize_game()

func initialize_game() -> void:
	game = get_tree().get_root().get_node('/root/Game')
	load_player_stats()
	music.playing = player_stats.play_music
	level_manager.load_level(get_current_level())
	
func get_current_level() -> int:
	if debug_mode: 
		player_stats.current_level = debug_level
		return debug_level
	
	return player_stats.current_level

func game_over() -> void:
	var level_tip = "TIP: " + level_manager.get_current_level_tip()
	EventBus.emit_signal("game_over", "lose", level_tip)

func load_player_stats():
	# Load the player's current stats
	var existing_stats = load("user://player_stats.tres")
	if existing_stats:
		player_stats = existing_stats
		return
	reinitialize_player_stats()
		
func reinitialize_player_stats() -> void:
	var new_player_stats = load("res://Lib/Unit/Stats/player_stats.tres")
	ResourceSaver.save(new_player_stats, "user://player_stats.tres")
	player_stats = new_player_stats

# Creates a persistent save on stat changes
func _on_Player_Stats_changed(new_player_stats) -> void:
	ResourceSaver.save(new_player_stats, "user://player_stats.tres")

func _on_reset_game() -> void:
	reinitialize_player_stats()
	get_tree().quit()
	
func _on_music_toggle(value: bool) -> void:
	music.playing = value
