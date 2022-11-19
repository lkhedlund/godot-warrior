extends Popup

onready var level_tip = $CentreContainer/StackedContent/LevelTip

func _ready() -> void:
	EventBus.connect("game_over", self, "_on_Game_Over")

func _on_TryAgainButton_pressed() -> void:
	get_tree().quit()

func _on_Game_Over(level_tip_text: String) -> void:
	get_tree().paused = true
	level_tip.text = level_tip_text
	self.visible = true
