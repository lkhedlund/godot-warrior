tool
class_name PlayerUnit
extends Unit

signal abilities_unlocked

var player
var player_stats

export var weapon_skin: Texture setget set_weapon_skin
export var weapon_offset: Vector2 setget set_weapon_offset

onready var _weapon_sprite: Sprite = $Weapon/Sprite

func _ready() -> void:
	player = get_tree().get_root().get_node('/root/Game/Demo')
	player_stats = GameManager.player_stats
	unlock_abilities()
	_weapon_sprite.visible = player_stats.has_unlocked("attack")
	._ready()

func take_turn() -> void:
	.take_turn() # super
	player.play_turn(self)
	
func has_ability(ability_name: String) -> bool:
	if GameManager.god_mode: return true

	for ability in abilities:
		if ability.name == ability_name and player_stats.has_unlocked(ability_name):
			return true
	return false

func set_health(_amount: int) -> void:
	var text = "You can't set your health directly. Use [color=red]rest()[/color] to heal"
	EventBus.emit_signal("update_log", text)

func set_weapon_skin(value: Texture) -> void:
	weapon_skin = value
	if not _weapon_sprite:
		yield(self, "ready")
	_weapon_sprite.texture = value
	
func set_weapon_offset(value: Vector2) -> void:
	weapon_offset = value
	if not _weapon_sprite:
		yield(self, "ready")
	_weapon_sprite.position = value
	
func unlock_abilities() -> void:
	var unlocked_abilities := {}
	for ability in abilities:
		if ability.level_unlocked <= player_stats.current_level:
			unlocked_abilities[ability.name] = ability
	player_stats.unlocked_abilities = unlocked_abilities

