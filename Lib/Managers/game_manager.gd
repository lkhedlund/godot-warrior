extends Node

var game

onready var level_manager: LevelManager = $LevelManager
onready var turn_manager: TurnManager = $TurnManager

func _process(_delta) -> void:
	if not game:
		initialize_game()
		return

func initialize_game() -> void:
	game = get_tree().get_root().get_node('/root/Game')
	# FIXME: Replace hardcoded level with Save data
	level_manager.load_level(1)
	EventBus.emit_signal("game_init")
