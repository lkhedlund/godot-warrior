extends Popup

var abilities
var ability_item_ui = preload("res://Lib/UI/ability_item.tscn")

onready var ability_list = $AbilityList

func _ready() -> void:
	abilities = GameManager.player_stats.abilities
	for ability in abilities:
		var ability_item = ability_item_ui.instance()
		ability_item.ability_name = ability.name
		ability_item.ability_description = ability.description
		# Add the item to the list
		ability_list.add_child(ability_item)
