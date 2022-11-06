class_name Exit
extends Node2D

var current_cell: Vector2

export var grid: Resource = preload("res://Lib/Grid/grid.tres")

func _ready():
	set_process(false)
	
	self.current_cell = grid.calculate_grid_coordinates(position)
	position = grid.calculate_map_position(current_cell)
	EventBus.connect("exit_level", self, "_on_Exit_level")

func _on_Exit_level() -> void:
	GameManager.level_manager.load_next_level()
