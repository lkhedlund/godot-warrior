class_name PlayerUnit
extends Unit

var player

func _ready() -> void:
	player = get_tree().get_root().get_node('/root/Game/Player')

func take_turn() -> void:
	.take_turn() # super
	player.play_turn(self)
