# Represents a unit on the game board.
# The board manages the Unit's position inside the game grid.
# The unit itself is only a visual representation that moves smoothly in the game world.
# We use the tool mode so the `skin` and `skin_offset` below update in the editor.
tool
class_name Unit
extends Path2D

signal move_finished

var game_board

export var grid: Resource = preload("res://Lib/Grid/grid.tres")
export var move_range := 1
export var skin: Texture setget set_skin
export var move_speed := 600
export(Array, Resource) var abilities: Array

var current_cell := Vector2.ZERO setget set_current_cell
var is_selected := false setget set_is_selected
var _is_moving := false setget _set_is_moving

onready var _sprite: Sprite = $PathFollow2D/Sprite
onready var _anim_player: AnimationPlayer = $AnimationPlayer
onready var _path_follow: PathFollow2D = $PathFollow2D

func initialize(board) -> void:
	game_board = board

func _ready() -> void:
	# Don't need the unit to update every frame
	set_process(false)
	
	self.current_cell = grid.calculate_grid_coordinates(position)
	position = grid.calculate_map_position(current_cell)
	
	# Create the curve resource here - creating in the editor prevented movement
	if not Engine.editor_hint:
		curve = Curve2D.new()
	
func _process(delta: float) -> void:
	_path_follow.offset += move_speed * delta
	
	# Increasing the offset represents how far along the curve the
	# unit has travelled, where a value 1.0 means the end
	var end_of_path = 1.0
	
	if _path_follow.unit_offset >= end_of_path:
		self._is_moving = false
		
		# Reset offset and move unit
		_path_follow.offset = 0.0
		position = grid.calculate_map_position(current_cell)
		curve.clear_points()
		emit_signal("move_finished")
		
func take_turn() -> void:
	print("Taking turn")
	game_board._select_unit(self)

func move_along_path(path: PoolVector2Array) -> void:
	if path.empty():
		return
		
	# Converts the path to points on the curve.
	curve.add_point(Vector2.ZERO)
	for point in path:
		curve.add_point(grid.calculate_map_position(point) - position)
		# Change the cell to the target position
		current_cell = path[-1]
		self._is_moving = true

# Abilities
func walk() -> void:
	#if not has_ability("walk"):
	#	return
	game_board.move_current_unit(current_cell + Vector2.RIGHT)

# Setters
func set_current_cell(value: Vector2) -> void:
	current_cell = grid.clamp(value)

func set_is_selected(value: bool) -> void:
	is_selected = value
	if is_selected:
		_anim_player.play("selected")
	else:
		_anim_player.play("idle")

func set_skin(value: Texture) -> void:
	skin = value
	if not _sprite:
		yield(self, "ready")
	_sprite.texture = value
	
func _set_is_moving(value: bool) -> void:
	_is_moving = value
	set_process(_is_moving)
	
func set_abilities(ability: Resource) -> void:
	abilities.append(ability)
	
func has_ability(ability_name: String) -> bool:
	for ability in abilities:
		if ability.name == ability_name:
			return true
	return false
