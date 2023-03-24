# Represents a unit on the game board.
# The board manages the Unit's position inside the game grid.
# The unit itself is only a visual representation that moves smoothly in the game world.
# We use the tool mode so the `skin` and `skin_offset` below update in the editor.
@tool
class_name Unit
extends Path2D

# warning-ignore:unused_signal
signal turn_over
signal move_finished
signal health_changed(amount, type)

var game_board

@export var unit_name: String
@export var grid: Resource = preload("res://Lib/Grid/grid.tres")
@export var max_health := 10
@export var move_range := 1
@export var move_speed := 600
@export var vision_range := 3
@export var max_action_points := 1
@export var damage := 5
@export var armor := 3
@export var direction : Vector2 = Vector2.LEFT
@export var abilities: Array # (Array, Resource)
@export var skin: Texture2D : set = set_skin

var health: int : set = set_health
var action_points: int : set = set_action_points
var current_cell := Vector2.ZERO : set = set_current_cell
var is_selected := false : set = set_is_selected
var _is_moving := false : set = _set_is_moving
var is_defending := false : set = set_is_defending

@onready var _sprite: Sprite2D = $PathFollow2D/Sprite2D
@onready var _anim_player: AnimationPlayer = $AnimationPlayer
@onready var _path_follow: PathFollow2D = $PathFollow2D

func initialize(board) -> void:
	game_board = board

func _ready() -> void:
	# Don't need the unit to update every frame
	set_process(false)
	health = max_health
	action_points = max_action_points
	
	self.current_cell = grid.calculate_grid_coordinates(position)
	position = grid.calculate_map_position(current_cell)
	
	# Create the curve resource here - creating in the editor prevented movement
	if not Engine.is_editor_hint():
		curve = Curve2D.new()
	
func _process(delta: float) -> void:
	_path_follow.offset += move_speed * delta
	
	# Increasing the offset represents how far along the curve the
	# unit has travelled, where a value 1.0 means the end
	var end_of_path = 1.0
	
	if _path_follow.progress_ratio >= end_of_path:
		self._is_moving = false
		
		# Reset offset and move unit
		_path_follow.offset = 0.0
		position = grid.calculate_map_position(current_cell)
		curve.clear_points()
		emit_signal("move_finished")
		
func take_turn() -> void:
	is_defending = false
	game_board._select_unit(self)

func move_along_path(path: PackedVector2Array) -> void:
	if path.is_empty():
		return
		
	# Converts the path to points on the curve.
	curve.add_point(Vector2.ZERO)
	for point in path:
		curve.add_point(grid.calculate_map_position(point) - position)
		# Change the cell to the target position
		current_cell = path[-1]
		if game_board.is_trap(current_cell):
			dead()
		self._is_moving = true
		
func take_damage(amount: int) -> void:
	if is_defending:
		amount += armor
	health = int(clamp(health + amount, 0, max_health))
	emit_signal("health_changed", amount, "damage")
	_anim_player.play("hurt")
	if health <= 0:
		dead()
	
func heal(amount: int) -> void:
	if health < max_health:
		health = int(clamp(health + amount, 0, max_health))
		emit_signal("health_changed", amount, "heal")

func dead() -> void:
	if self.is_in_group("player"):
		GameManager.game_over()
	else:
		game_board.remove_unit_at_position(current_cell)
	await _anim_player.animation_finished
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

func use_ability(ability_name: String, params={}):
	if not has_ability(ability_name): return
	
	var ability = load_ability(ability_name)

	if not can_use_ability(ability) && self.is_in_group("player"):
		var log_text = "You don't have enough action points to %s!" % ability.name
		EventBus.emit_signal("update_player_log", log_text)
		return

	log_action(ability)
	reduce_ap(ability.action_cost)
	return ability.perform(self, params)

func can_use_ability(ability) -> bool:
	return (action_points - ability.action_cost) >= 0

func reduce_ap(cost: int) -> void:
	action_points -= cost

func reset() -> void:
	action_points = max_action_points

func log_action(ability) -> void:
	if ability.action_cost < 1: return

	var extra_log = "%s performed [color=red]%s[/color] action" % [self.unit_name, ability.name]
	if self.is_in_group("enemy"):
		extra_log = "[color=silver]%s[/color]" % extra_log
	EventBus.emit_signal("update_player_log", extra_log, "extra")

# Helper methods
func walk() -> void:
	use_ability("walk")

func attack() -> void:
	use_ability("attack", { "damage": damage })
	
func disarm() -> void:
	use_ability("disarm")
	
func shoot(target_unit: Unit) -> void:
	var params = {
		"damage": damage - 2,
		"target_unit": target_unit
	}
	use_ability("shoot", params)
	
func rest() -> void:
	use_ability("rest")
	
func defend() -> void:
	use_ability("defend")
	
func look() -> Array:
	return use_ability("look")
	
func feel(unit_type: String) -> bool:
	return use_ability("feel", { "unit_type": unit_type })

# Setters
func set_current_cell(value: Vector2) -> void:
	current_cell = grid.clamp(value)

func set_is_selected(value: bool) -> void:
	is_selected = value
	
func set_is_defending(value: bool) -> void:
	is_defending = value

func set_skin(value: Texture2D) -> void:
	skin = value
	if not _sprite:
		if is_instance_valid(self):
			await self.ready
	_sprite.texture = value
	
func set_health(amount: int) -> void:
	health = int(clamp(health + amount, 0, max_health))
	emit_signal("health_changed", amount)
	
func set_action_points(amount: int) -> void:
	action_points = int(clamp(action_points + amount, 0, max_action_points))
	
func _set_is_moving(value: bool) -> void:
	_is_moving = value
	set_process(_is_moving)
