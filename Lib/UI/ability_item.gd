extends HBoxContainer

var ability_cost: int
var ability_name: String
var ability_description: String

onready var name_ui = $AbilityDetails/AbilityName
onready var cost_ui = $AbilityDetails/AbilityCost
onready var description_ui = $AbilityDescription

func _ready():
	name_ui.text = ability_name
	cost_ui.text = "Cost: " + str(ability_cost)
	description_ui.bbcode_text = ability_description
