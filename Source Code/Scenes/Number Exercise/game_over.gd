extends CenterContainer


signal play_again_pressed()

@onready var go_window: Control = $"."
@onready var go_title: Control = $"PanelContainer/VBoxContainer/GO Title"
@onready var score: Control = $PanelContainer/VBoxContainer/Score
@onready var play_again_button: Control = $"PanelContainer/VBoxContainer/Play Again"

var language_selected: String = SessionManager.current_save.language_selected


func _ready() -> void:
	pass


func _on_play_again_pressed() -> void:
	play_again_pressed.emit()


func _signal_dead_emitted(current_score: int) -> void:
	if language_selected == "English":
		go_title.text = "Game Over"
		score.text = "Score: " + NumFuncs.add_commata(current_score)
		play_again_button.text = "Play Again"
	elif language_selected == "Deutsch":
		go_title.text = "Spiel vorbei"
		score.text = "Score: " + NumFuncs.add_commata(current_score)
		play_again_button.text = "Nochmal spielen"
