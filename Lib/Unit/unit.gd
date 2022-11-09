# Represents a unit on the game board.
# The board manages the Unit's position inside the game grid.
# The unit itself is only a visual representation that moves smoothly in the game world.
# We use the tool mode so the `skin` and `skin_offset` below update in the editor.
tool
class_name Unit
extends Path2D

signal move_finished

var game_board

export var unit_name: String
export var grid: Resource = preload("res://Lib/Grid/grid.tres")
export var max_health := 10
export var move_range := 1
export var move_speed := 600
export var direction : Vector2 = Vector2.LEFT
export(Array, Resource) var abilities: Array
export var skin: Texture setget set_skin

var health: int setget set_health
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
	health = max_health
	
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
		
func dead() -> void:
	game_board.remove_unit_at_position(current_cell)
	self.queue_free()

# Abilities
func has_ability(ability_name: String) -> bool:
	for ability in abilities:
		if ability.name == ability_name:
			return true
	return false
	
func load_ability(ability_name: String):
	for ability in abilities:
		if ability.name == ability_name:
			return ability

func walk() -> void:
	if not has_ability("walk"): return

	var next_cell = current_cell + Vector2.LEFT

	if not game_board.is_occupied(next_cell):
		game_board.move_current_unit(next_cell)

func attack() -> void:
	if not has_ability("attack"): return
	
	var next_cell: Vector2 = current_cell + direction
	if game_board.is_occupied(next_cell):
		var adjacent_unit = game_board.get_unit_at_position(next_cell)
		var attack = load_ability("attack")
		if adjacent_unit and attack:
			attack.do_damage(adjacent_unit)
	
func feel(unit_type: String) -> bool:
	if not has_ability("feel"): return false

	var next_cell: Vector2 = current_cell + direction
	if game_board.is_occupied(next_cell):
		var adjacent_unit = game_board.get_unit_at_position(next_cell)
		return adjacent_unit.is_in_group(unit_type)
	else:
		return false
		
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
	
func set_health(damage: int) -> void:
	health = clamp(health - damage, 0, max_health)
	print(health)
	if health <= 0:
		dead()
	EventBus.emit_signal("health_changed", self, health)
	
func _set_is_moving(value: bool) -> void:
	_is_moving = value
	set_process(_is_moving)
