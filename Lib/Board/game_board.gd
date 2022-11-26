# Represents and manages the game board. Stores references to units in
# each cell and manages whether a cell is occupied.
class_name GameBoard
extends Node2D
#extends YSort

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

var current_unit: Unit
var _walkable_cells := []

export var grid: Resource = preload("res://Lib/Grid/grid.tres")
export var starting_position := Vector2(0, 0)

onready var _unit_path: UnitPath = $UnitPath
onready var _unit_overlay: UnitOverlay = $UnitOverlay
onready var _exit: Exit = $Exit
onready var _turn_manager: TurnManager = $TurnManager

# Dictionary to keep track of units on the board
var _units := {}
var _traps := {}

func _ready() -> void:
	EventBus.connect("trap_disarmed", self, "_on_trap_disarmed")
	_reinitialize()

func is_occupied(cell: Vector2) -> bool:
	if _units.has(cell) and grid.is_within_bounds(cell):
		return true
	
	return false

# Clears and refills the `_units` dict with game objects on the board
func _reinitialize() -> void:
	_units.clear()

	for unit in get_tree().get_nodes_in_group("unit"):
		# Initialize the gameboard for the unit
		unit.initialize(self)
		_units[unit.current_cell] = unit
		_turn_manager.add_turn_to_queue(unit)
		
	for trap in get_tree().get_nodes_in_group("trap"):
		_traps[trap.current_cell] = trap

	# Start the round
	EventBus.emit_signal("unit_turns_loaded")

func get_walkable_cells(unit: Unit) -> Array:
	return _flood_fill(unit.current_cell, unit.move_range)
	
func get_visible_cells(unit: Unit) -> Array:
	var starting_cell = unit.current_cell + current_unit.direction
	var cells = _flood_fill(starting_cell, unit.vision_range - 2)
	if GameManager.debug_mode:
		_unit_overlay.draw(cells)
	return cells
	
func remove_unit_at_position(cell: Vector2) -> void:
	var dead_unit = _units[cell]
	_turn_manager.remove_turn_from_queue(dead_unit)
	_units.erase(cell)
	
func get_unit_at_position(cell: Vector2) -> Unit:
	return _units[cell]
	
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
		var coordinates: Vector2 = current + current_unit.direction
		if coordinates in walkable_cells:
			continue
				
		stack.append(coordinates)
	
	return walkable_cells

func _select_unit(unit: Unit) -> void:
	# Once unit is selected, turn on overlay and path drawing
	current_unit = unit
	current_unit.is_selected = true
	_walkable_cells = get_walkable_cells(current_unit)
	_unit_path.initialize(_walkable_cells)
	
func _deselect_player_unit() -> void:
	current_unit.is_selected = false
	_unit_overlay.clear()
	_unit_path.stop()
	
func move_current_unit(new_cell: Vector2) -> void:
	if not current_unit: return
	if not current_unit.is_selected: return
	if is_occupied(new_cell) or not new_cell in _walkable_cells: return
		
	var current_path = _unit_path.set_path(current_unit.current_cell, new_cell)
	_unit_path.draw(current_path)
	# When moving a unit we need to update the unit's dict.
	_units.erase(current_unit.current_cell)
	_units[new_cell] = current_unit
	
	_deselect_player_unit()
	current_unit.move_along_path(_unit_path.current_path)
	yield(current_unit, "move_finished")
	
func is_exit(cell: Vector2) -> bool:
	return _exit.current_cell == cell
	
func is_trap(cell: Vector2) -> bool:
	return _traps.has(cell)
	
# SIGNALS
func _on_trap_disarmed(cell: Vector2) -> void:
	if is_trap(cell):
		_traps[cell].queue_free()
		_traps.erase(cell)
