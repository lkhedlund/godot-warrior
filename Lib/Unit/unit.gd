# Represents a unit on the game board.
# The board manages the Unit's position inside the game grid.
# The unit itself is only a visual representation that moves smoothly in the game world.
# We use the tool mode so the `skin` and `skin_offset` below update in the editor.
tool
class_name Unit
extends Path2D

signal dead
signal move_finished
signal health_changed(amount, type)

var game_board

export var unit_name: String
export var grid: Resource = preload("res://Lib/Grid/grid.tres")
export var max_health := 10
export var move_range := 1
export var move_speed := 600
export var vision_range := 3
export var action_points := 1
export var damage := 5
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
		if game_board.is_trap(current_cell):
			dead()
			emit_signal("dead")
		self._is_moving = true
		
func take_damage(amount: int) -> void:
	health = int(clamp(health + amount, 0, max_health))
	emit_signal("health_changed", amount, "damage")
	_anim_player.play("hurt")
	if health <= 0:
		#yield(_anim_player, "animation_finished")
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
	emit_signal("dead")
	self.queue_free()

# Abilities
func has_ability(ability_name: String) -> bool:
	if self.is_in_group("player"):
		var unlocked = GameManager.player_stats.unlocked_abilities
		if not unlocked.has(ability_name): return false

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
	action_points = int(clamp(action_points - cost, 0, 1))

func reset_ap() -> void:
	action_points = 1

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
	
func look() -> Array:
	return use_ability("look")
	
func feel(unit_type: String) -> bool:
	return use_ability("feel", { "unit_type": unit_type })
	
func log_action(ability) -> void:
	if ability.action_cost < 1: return

	var extra_log = "%s performed [color=red]%s[/color] action" % [self.unit_name, ability.name]
	if self.is_in_group("enemy"):
		extra_log = "[color=silver]%s[/color]" % extra_log
	EventBus.emit_signal("update_player_log", extra_log, "extra")

# Setters
func set_current_cell(value: Vector2) -> void:
	current_cell = grid.clamp(value)

func set_is_selected(value: bool) -> void:
	is_selected = value

func set_skin(value: Texture) -> void:
	skin = value
	if not _sprite:
		yield(self, "ready")
	_sprite.texture = value
	
func set_health(amount: int) -> void:
	health = int(clamp(health + amount, 0, max_health))
	emit_signal("health_changed", amount)
	
func _set_is_moving(value: bool) -> void:
	_is_moving = value
	set_process(_is_moving)
