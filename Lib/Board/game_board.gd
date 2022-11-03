# Represents and manages the game board. Stores references to units in
# each cell and manages whether a cell is occupied.
class_name GameBoard
extends Node2D
#extends YSort

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

var player_unit: Unit
var _walkable_cells := []

export var grid: Resource = preload("res://Lib/Grid/grid.tres")
export var starting_position := Vector2(0, 0)

onready var _unit_path: UnitPath = $UnitPath
onready var _unit_overlay: UnitOverlay = $UnitOverlay

# Dictionary to keep track of units on the board
var _units := {}

func _ready() -> void:
	_reinitialize()

func is_occupied(cell: Vector2) -> bool:
	return true if _units.has(cell) else false

# Clears and refills the `_units` dict with game objects on the board
func _reinitialize() -> void:
	_units.clear()
	
	# Loop over node's children and filter units
	# FIXME: Use node group feature to place units anywhere on the scene tree
	for child in get_children():
		# Cast's the child to given type - will be null if wrong type
		var unit := child as Unit
		if not unit:
			continue
			
		_units[unit.current_cell] = unit
	
	player_unit = get_tree().get_nodes_in_group("Player")[0]
	_select_unit(player_unit.current_cell)

func get_walkable_cells(unit: Unit) -> Array:
	return _flood_fill(unit.current_cell, unit.move_range)
	
func _flood_fill(cell: Vector2, max_distance: int) -> Array:
	var walkable_cells := []
	
	# Use stack to store every cell to apply the flood fill to
	var stack := [cell]
	while not stack.empty():
		var current = stack.pop_back()
		
		# For each cell, ensure we can fill further
		#
		# Conditions:
		# 1. We didn't go past the grid's limits.
		# 2. We haven't already visit and filled this cell
		# 3. We are within the `max_distance`
		if not grid.is_within_bounds(current):
			continue
		if current in walkable_cells:
			continue
			
		# Check for the distance between starting and current cells
		var difference: Vector2 = (current - cell).abs()
		var distance := int(difference.x + difference.y)
		if distance > max_distance:
			continue
		
		# If we pass early return conditions, fill the cell
		walkable_cells.append(current)
		
		# look at neighbours of current cell and fill if unoccupied
		for direction in DIRECTIONS:
			var coordinates: Vector2 = current + direction
			if is_occupied(coordinates):
				continue
			if coordinates in walkable_cells:
				continue
				
			stack.append(coordinates)
	
	return walkable_cells

# Selects unit in the cell if there is one, sets as
# active unit, and draws walkable cells.
func _select_unit(cell: Vector2) -> void:
	# Return early if unit is not registered
	if not _units.has(cell):
		return
		
	# Once unit is selected, turn on overlay and path drawing
	player_unit = _units[cell]
	player_unit.is_selected = true
	_walkable_cells = get_walkable_cells(player_unit)
	_unit_overlay.draw(_walkable_cells)
	_unit_path.initialize(_walkable_cells)
	
func _deselect_player_unit() -> void:
	player_unit.is_selected = false
	_unit_overlay.clear()
	_unit_path.stop()
	
func _clear_player_unit() -> void:
	player_unit = null
	_walkable_cells.clear()
	
func _move_player_unit(new_cell: Vector2) -> void:
	if is_occupied(new_cell) or not new_cell in _walkable_cells:
		return
		
	# When moving a unit we need to update the unit's dict.
	_units.erase(player_unit.current_cell)
	_units[new_cell] = player_unit
	
	_deselect_player_unit()
	player_unit.move_along_path(_unit_path.current_path)
	yield(player_unit, "move_finished")
	_clear_player_unit()

func _on_Cursor_moved_cursor(new_cell):
	if player_unit and player_unit.is_selected:
		_unit_path.draw(player_unit.current_cell, new_cell)
		
func _unhandled_input(event: InputEvent) -> void:
	if player_unit and event.is_action_pressed("ui_cancel"):
		_deselect_player_unit()
		_clear_player_unit()
