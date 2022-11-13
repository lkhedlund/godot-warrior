extends HBoxContainer


var ability_name: String
var ability_description: String

onready var name_ui = $AbilityName
onready var description_ui = $AbilityDescription

func _ready():
	name_ui.text = ability_name
	description_ui.bbcode_text = ability_description
