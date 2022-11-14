class_name PlayerUnit
extends Unit

var player
var player_stats
var unlocked_abilities

onready var sword = $Sword

func _ready() -> void:
	EventBus.connect("ability_gained", self, "_on_Ability_gained")
	player = get_tree().get_root().get_node('/root/Game/Demo')
	player_stats = GameManager.player_stats
	unlocked_abilities = player_stats.unlocked_abilities
	._ready()

func take_turn() -> void:
	.take_turn() # super
	player.play_turn(self)
	
func set_health(_amount: int) -> void:
	pass

func _on_Ability_gained(ability: Ability) -> void:
	if ability.name == "attack":
		sword.visible = true

