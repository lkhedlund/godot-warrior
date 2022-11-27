tool
class_name PlayerUnit
extends Unit

var player
var player_stats

onready var _weapon_sprite: Sprite = $Weapon/Sprite
onready var _shield_sprite: Sprite = $Shield/Sprite

func _ready() -> void:
	player = get_tree().get_root().get_node('/root/Game/Player')
	player_stats = GameManager.player_stats
	unlock_abilities()
	_weapon_sprite.visible = player_stats.has_unlocked("attack")
	_shield_sprite.visible = player_stats.has_unlocked("defend")
	._ready()

func take_turn() -> void:
	.take_turn() # super
	player.play_turn(self)
	emit_signal("turn_over")
	
func has_ability(ability_name: String) -> bool:
	if GameManager.god_mode: return true

	for ability in abilities:
		if ability.name == ability_name and player_stats.has_unlocked(ability_name):
			return true
	return false

func set_health(_amount: int) -> void:
	var text = "You can't set your health directly. Use [color=red]rest()[/color] to heal"
	EventBus.emit_signal("update_log", text)
	
func unlock_abilities() -> void:
	var unlocked_abilities := {}
	for ability in abilities:
		if ability.level_unlocked <= player_stats.current_level:
			unlocked_abilities[ability.name] = ability
	player_stats.unlocked_abilities = unlocked_abilities

func is_empty(space: Vector2) -> bool:
	return game_board.is_occupied(space)
