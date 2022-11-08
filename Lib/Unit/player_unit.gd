class_name PlayerUnit
extends Unit

var player

onready var sword = $Sword

func _ready() -> void:
	EventBus.connect("ability_gained", self, "_on_Ability_gained")
	player = get_tree().get_root().get_node('/root/Game/Player')
	._ready()

func take_turn() -> void:
	.take_turn() # super
	player.play_turn(self)

func walk() -> void:
	if not has_ability("walk"): return

	var next_cell = current_cell + Vector2.RIGHT
	if game_board.is_exit(next_cell):
		game_board.move_current_unit(next_cell)
		EventBus.emit_signal("exit_level")
		
	if not game_board.is_occupied(next_cell):
		game_board.move_current_unit(next_cell)

func _on_Ability_gained(ability: Ability) -> void:
	if ability.name == "attack":
		sword.visible = true
