# Player controller cursor. Allows grid navigation, unit selection, and unit movement.
# Support keyboard, mouse, and touch.
tool
class_name Cursor
extends Node2D

# Use signals to keep the cursor decoupled from other nodes.

signal accept_pressed(cell)
signal moved_cursor(new_cell)

export var grid: Resource = preload("res://Lib/Grid/grid.tres")
# Time before the cursor can move again
export var ui_cooldown := 0.1

# Coordiates of the current cell the cursor is hovering over
var cell := Vector2.ZERO setget set_cell

onready var _timer: Timer = $Timer

func _ready() -> void:
	_timer.wait_time = ui_cooldown
	position = grid.calculate_map_position(cell)

func _draw() -> void:
	# Rect2 is built from the position of the top-left corner and its size.
	# Start position needs to be `-grid.cell_size / 2` to draw square.
	draw_rect(Rect2(-grid.cell_size / 2, grid.cell_size), Color.aliceblue, false, 2.0)
	
# Controllers the cursor's current position
func set_cell(value: Vector2) -> void:
	var new_cell: Vector2 = grid.clamp(value)
	if new_cell.is_equal_approx(cell):
		return
		
	cell = new_cell
	position = grid.calculate_map_position(cell)
	emit_signal("moved_cursor", cell)
	_timer.start()
