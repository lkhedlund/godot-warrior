extends Control

var portrait = preload("res://Lib/UI/unit_portrait.tscn")

var portrait_queue := {}

onready var turn_portraits = $TurnPortraits

func _ready():
	EventBus.connect("start_round", self, "_on_start_round")
	EventBus.connect("start_turn", self, "_on_start_turn")
	EventBus.connect("end_turn", self, "_on_end_turn")
	
func _on_start_round(turn_queue: Array) -> void:
	for unit in turn_queue:
		var unit_portrait = portrait.instance()
		turn_portraits.add_child(unit_portrait)
		portrait_queue[unit] = unit_portrait
	
func _on_start_turn(unit: Unit) -> void:
	pass

func _on_end_turn(unit: Unit) -> void:
	if portrait_queue.has(unit):
		portrait_queue[unit].queue_free()
