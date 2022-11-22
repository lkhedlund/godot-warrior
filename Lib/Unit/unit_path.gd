class_name UnitPath
extends TileMap

export var grid: Resource

# Holds a reference to the PathFinder object.
var _pathfinder: PathFinder
# Caches the path found by the _pathfinder so that it can be passed
# to the gameboard
var current_path := PoolVector2Array()

func initialize(walkable_cells: Array) -> void:
	_pathfinder = PathFinder.new(grid, walkable_cells)
	
func set_path(cell_start: Vector2, cell_end: Vector2) -> PoolVector2Array:
	clear()
	current_path = _pathfinder.calculate_point_path(cell_start, cell_end)
	return current_path

# warning-ignore:shadowed_variable
func draw(current_path: PoolVector2Array) -> void:
	for cell in current_path:
		set_cellv(cell, 0)

func stop() -> void:
	_pathfinder = null
	clear()
