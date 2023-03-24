extends Popup

@onready var label = $CentreContainer/GameOverContent/ConditionLabel
@onready var extra_text = $CentreContainer/GameOverContent/ExtraText

func _ready() -> void:
	EventBus.connect("game_over",Callable(self,"_on_Game_Over"))

func _on_TryAgainButton_pressed() -> void:
	get_tree().quit()

func _on_Game_Over(type: String, game_over_text: String) -> void:
	get_tree().paused = true
	var default_label = "[shake rate=10 level=2]You Died[/shake]"
	if type == "win":
		default_label = "[rainbow freq=0.2 sat=10 val=20]You Win![/rainbow]"
	label.text = default_label
	extra_text.text = game_over_text
	self.visible = true
