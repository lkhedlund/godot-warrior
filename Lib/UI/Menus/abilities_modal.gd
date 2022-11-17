extends ModalMenu

export(Array, Resource) var abilities : Array
var ability_item_ui = preload("res://Lib/UI/ability_item.tscn")

onready var ability_list = $AbilityList

func add_ability_to_list(ability: Resource) -> void:
		var ability_item = ability_item_ui.instance()
		ability_item.ability_name = ability.name
		ability_item.ability_cost = ability.action_cost
		ability_item.ability_description = ability.description
		# Add the item to the list
		ability_list.add_child(ability_item)
