class_name PlayerUnit
extends Unit

var player
var player_stats

onready var sword = $Sword

func _ready() -> void:
	EventBus.connect("ability_gained", self, "_on_Ability_gained")
	player = get_tree().get_root().get_node('/root/Game/Player')
	player_stats = GameManager.player_stats
	abilities = GameManager.player_stats.abilities
	._ready()

func take_turn() -> void:
	.take_turn() # super
	player.play_turn(self)

func walk() -> void:
	if not has_ability("walk"): return

	var next_cell = current_cell + direction
	if not game_board.is_occupied(next_cell):
		game_board.move_current_unit(next_cell)

	if game_board.is_exit(next_cell):
		game_board.move_current_unit(next_cell)
		EventBus.emit_signal("exit_level")

func attack() -> void:
	.attack() # super
	EventBus.emit_signal("update_player_log", "")

func _on_Ability_gained(ability: Ability) -> void:
	if ability.name == "attack":
		sword.visible = true
