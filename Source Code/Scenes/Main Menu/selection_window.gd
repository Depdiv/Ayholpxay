extends CenterContainer


@onready var main_menu: Control = $"../Main Menu"
@onready var selection_window: Control = $"."
@onready var title: Control = $PanelContainer/VBoxContainer/Title
@onready var number_converter_button: Control = $"PanelContainer/VBoxContainer/Number Converter"
@onready var number_exercise_button: Control = $"PanelContainer/VBoxContainer/Number Exercise"
@onready var back_button: Control = $PanelContainer/VBoxContainer/Back

func _ready() -> void:
	_change_language()


func _on_back_pressed() -> void:
	selection_window.visible = false
	main_menu.visible = true


func _on_number_converter_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Number Converter/number_converter.tscn")


func _on_number_exercise_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Number Exercise/number_exercise.tscn")


func _change_language() -> void:
	title.text = "Ayholpxay"
	
	if SessionManager.current_save.language_selected == "English":
		number_converter_button.text = "Number Converter"
		number_exercise_button.text = "Number Exercise"
		back_button.text = "Back"
	elif SessionManager.current_save.language_selected == "Deutsch":
		number_converter_button.text = "Zahlenumrechner"
		number_exercise_button.text = "Übungsspiel"
		back_button.text = "Zurück"


func _on_main_menu_selection_window_on() -> void:
	_change_language()
