extends Label

onready var damage_tween = $DamageTween

func show_value(value, travel, duration, spread, heal) -> void:
	if heal:
		modulate = Color.green
	text = value
	rect_pivot_offset = rect_size / 2
	var rand_duration = rand_range(1, duration)
	var movement = travel.rotated(rand_range(-spread/2, spread/2))
	damage_tween.interpolate_property(
		self,
		"rect_position",
		rect_position,
		rect_position + movement,
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
	yield(damage_tween, "tween_all_completed")
	queue_free()
