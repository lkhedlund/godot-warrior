extends Label

@onready var damage_tween = $DamageTween

func show_value(value, travel, duration, spread, heal) -> void:
	if heal:
		modulate = Color.GREEN
	text = value
	pivot_offset = size / 2
	var rand_duration = randf_range(1, duration)
	var movement = travel.rotated(randf_range(-spread/2, spread/2))
	damage_tween.interpolate_property(
		self,
		"position",
		position,
		position + movement,
		rand_duration,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	damage_tween.interpolate_property(
		self,
		"modulate:a",
		1.0,
		0.0,
		rand_duration,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	damage_tween.start()
	await damage_tween.tween_all_completed
	queue_free()
