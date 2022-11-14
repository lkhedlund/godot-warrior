tool
class_name PlayerUnit
extends Unit

var player
var player_stats
var unlocked_abilities

export var weapon_skin: Texture setget set_weapon_skin
export var weapon_offset: Vector2 setget set_weapon_offset

onready var _weapon_sprite: Sprite = $Weapon/Sprite

func _ready() -> void:
	player = get_tree().get_root().get_node('/root/Game/Demo')
	player_stats = GameManager.player_stats
	unlocked_abilities = player_stats.unlocked_abilities
	_weapon_sprite.visible = player_stats.has_unlocked("attack")
	._ready()

func take_turn() -> void:
	.take_turn() # super
	player.play_turn(self)
	
func set_health(_amount: int) -> void:
	pass

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

func _on_Ability_gained(ability: Ability) -> void:
	if ability.name == "attack":
		_weapon_sprite.visible = true
