# Finds the path between two points among empty cells using 
# the AStar pathfinding algorithm
class_name PathFinder
extends Reference

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

var _grid: Resource
var _astar := AStar2D.new()

# Initialize the Astar2D object upon creation
func _init(grid: Grid, walkable_cells: Array) -> void:
	# Initialize grid from UnitPath on instantiation
	_grid = grid
	
	# Get index from each grid cell, and cache the mapping 
	# between the coordinates and their unique index.
	var cell_mappings := {}
	for cell in walkable_cells:
		# Define a key/value pair of cell coordinates: index.
		cell_mappings[cell] = _grid.as_index(cell)
		
	# Add all the cells to Astar2D instance and connect them to create
	# a pathfinding graph.
	_add_and_connect_points(cell_mappings)

func calculate_point_path(start: Vector2, end: Vector2) -> PoolVector2Array:
	var start_index: int = _grid.as_index(start)
	var end_index: int = _grid.as_index(end)
	
	if _astar.has_point(start_index) and _astar.has_point(end_index):
		# Astar2D then finds the best path between two indices.
		return _astar.get_point_path(start_index, end_index)
	else:
		return PoolVector2Array()
		
# Adds and connects the walkable cells to the Astar2D object
func _add_and_connect_points(cell_mappings: Dictionary) -> void:
	# Pass each cell's unique index and Vector2 Coordinates to the AStar graph
	for point in cell_mappings:
		_astar.add_point(cell_mappings[point], point)
	
	# Connect all points to their neighbour
	for point in cell_mappings:
		for neighbour_index in _find_neighbour_indices(point, cell_mappings):
			_astar.connect_points(cell_mappings[point], neighbour_index)

func _find_neighbour_indices(cell: Vector2, cell_mappings: Dictionary) -> Array:
	var out := []
	
	# Try to move one cell in every direction and check for existing connections
	for direction in DIRECTIONS:
		var neighbour: Vector2 = cell + direction
		
		# Skip cells that are not available to move to
		if not cell_mappings.has(neighbour):
			continue
			
		# Check for existing connections
		if not _astar.are_points_connected(cell_mappings[cell], cell_mappings[neighbour]):
			out.push_back(cell_mappings[neighbour])
	return out
