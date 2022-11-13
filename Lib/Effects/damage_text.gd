extends Label

onready var damage_tween = $DamageTween

func show_value(value, travel, duration, heal) -> void:
	if heal:
		modulate = Color.green
	text = value
	rect_pivot_offset = rect_size / 2
	damage_tween.interpolate_property(
		self,
		"rect_position",
		rect_position,
		rect_position + travel,
		duration,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	damage_tween.interpolate_property(
		self,
		"modulate:a",
		1.0,
		0.0,
		duration,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	damage_tween.start()
	yield(damage_tween, "tween_all_completed")
	queue_free()
