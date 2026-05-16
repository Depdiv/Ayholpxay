extends Button

@onready var syllable_button: Control = $"."

@export var index: int = 0


func _ready() -> void:
	pass


func _on_pressed() -> void:
	if syllable_button.text == syllable_button.text.to_upper():
		syllable_button.text = syllable_button.text.to_lower()
	else:
		syllable_button.text = syllable_button.text.to_upper()
