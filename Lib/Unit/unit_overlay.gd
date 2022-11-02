# Draws an overlay over an array of cells
class_name UnitOverlay
extends TileMap

func draw(cells: Array) -> void:
	clear()
	# Assign the only tile available in the tileset
	for cell in cells:
		set_cellv(cell, 0)
