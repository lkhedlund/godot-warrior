class_name Interactable
extends Node2D

var current_cell: Vector2

@export var grid: Resource = preload("res://Lib/Grid/grid.tres")

func _ready():
	initialize()

func initialize() -> void:
	set_process(false)
	self.current_cell = grid.calculate_grid_coordinates(position)
	position = grid.calculate_map_position(current_cell)
