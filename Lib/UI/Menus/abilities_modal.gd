extends ModalMenu

var abilities := []
var ability_item_ui = preload("res://Lib/UI/ability_item.tscn")

@onready var ability_list = $ScrollContainer/AbilityList

func add_ability_to_list(ability: Resource) -> void:
	if abilities.has(ability.name): return

	var ability_item = ability_item_ui.instantiate()
	ability_item.ability_name = ability.name
	ability_item.ability_cost = ability.action_cost
	ability_item.ability_description = ability.description
	# Add the item to the list
	ability_list.add_child(ability_item)
	abilities.append(ability.name)
