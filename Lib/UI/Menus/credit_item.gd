@tool
extends VBoxContainer

@export var label := ""
@export var link := ""

@onready var credit_label = $CreditLabel
@onready var credit_link = $CreditLink

func _ready() -> void:
	credit_label.text = label
	credit_link.text = link
