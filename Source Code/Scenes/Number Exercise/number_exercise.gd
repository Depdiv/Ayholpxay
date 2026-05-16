extends CenterContainer


signal octal_deci_button_pressed()

@onready var from_x_to_y_window: Control = $"../From X To Y Window"
@onready var main_window: Control = $"."
@onready var title: Control = $PanelContainer/VBoxContainer/Title
@onready var octal_deci_button: Control = $PanelContainer/VBoxContainer/OctalDeci
@onready var x_to_y_button: Control = $"PanelContainer/VBoxContainer/X To Y"
@onready var life_button: Control = $PanelContainer/VBoxContainer/Life
@onready var emphasis_button: Control = $PanelContainer/VBoxContainer/Emphasis
@onready var name_number_button: Control = $"PanelContainer/VBoxContainer/Name Number"
@onready var confirm_button: Control = $PanelContainer/VBoxContainer/Confirm
@onready var back_to_main_menu_button: Control = $"../Back To Main Menu"
@onready var version: Control = $"../Version"


func _ready() -> void:
	_change_language()
	
	version.text = SessionManager.current_save.current_version


func _on_back_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main Menu/main.tscn")


func _check_eight_or_nine(num: int) -> bool:
	var result: bool = false
	
	for i: String in str(num):
		if i == "8" or i == "9":
			result = true
			break
	
	return result
func _on_octal_deci_pressed() -> void:
	var x: int = SessionManager.current_save.x
	var y: int = SessionManager.current_save.y
	
	if SessionManager.current_save.language_selected == "English":
		if SessionManager.current_save.octal2deci == true:
			SessionManager.current_save.octal2deci = false
			SaveManager.save_game(SessionManager.current_save)
			octal_deci_button_pressed.emit()
		else:
			if _check_eight_or_nine(x) == false and _check_eight_or_nine(y) == false:
				SessionManager.current_save.octal2deci = true
				SaveManager.save_game(SessionManager.current_save)
				octal_deci_button_pressed.emit()
	elif SessionManager.current_save.language_selected == "Deutsch":
		if SessionManager.current_save.octal2deci == true:
			SessionManager.current_save.octal2deci = false
			SaveManager.save_game(SessionManager.current_save)
			octal_deci_button_pressed.emit()
		else:
			if _check_eight_or_nine(x) == false and _check_eight_or_nine(y) == false:
				SessionManager.current_save.octal2deci = true
				SaveManager.save_game(SessionManager.current_save)
				octal_deci_button_pressed.emit()


func _on_life_pressed() -> void:
	if SessionManager.current_save.language_selected == "English":
		if SessionManager.current_save.life < 5:
			SessionManager.current_save.life += 1
			SaveManager.save_game(SessionManager.current_save)
			life_button.text = "Life: " + str(SessionManager.current_save.life)
		else:
			SessionManager.current_save.life = 1
			SaveManager.save_game(SessionManager.current_save)
			life_button.text = "Life: " + str(SessionManager.current_save.life)
	elif SessionManager.current_save.language_selected == "Deutsch":
		if SessionManager.current_save.life < 5:
			SessionManager.current_save.life += 1
			SaveManager.save_game(SessionManager.current_save)
			life_button.text = "Leben: " + str(SessionManager.current_save.life)
		else:
			SessionManager.current_save.life = 1
			SaveManager.save_game(SessionManager.current_save)
			life_button.text = "Leben: " + str(SessionManager.current_save.life)


func _on_emphasis_pressed() -> void:
	if SessionManager.current_save.language_selected == "English":
		if SessionManager.current_save.find_emphasis_on == true:
			SessionManager.current_save.find_emphasis_on = false
			SaveManager.save_game(SessionManager.current_save)
			emphasis_button.text = "Find Emphasis: off"
		else:
			SessionManager.current_save.find_emphasis_on = true
			SaveManager.save_game(SessionManager.current_save)
			emphasis_button.text = "Find Emphasis: on"

	elif SessionManager.current_save.language_selected == "Deutsch":
		if SessionManager.current_save.find_emphasis_on == true:
			SessionManager.current_save.find_emphasis_on = false
			SaveManager.save_game(SessionManager.current_save)
			emphasis_button.text = "Finde die Betonung: aus"
		else:
			SessionManager.current_save.find_emphasis_on = true
			SaveManager.save_game(SessionManager.current_save)
			emphasis_button.text = "Finde die Betonung: an"


func _on_name_number_pressed() -> void:
	if SessionManager.current_save.language_selected == "English":
		if SessionManager.current_save.name_number_on == true:
			SessionManager.current_save.name_number_on = false
			SaveManager.save_game(SessionManager.current_save)
			name_number_button.text = "Name The Number: off"
		else:
			SessionManager.current_save.name_number_on = true
			SaveManager.save_game(SessionManager.current_save)
			name_number_button.text = "Name The Number: on"
	elif SessionManager.current_save.language_selected == "Deutsch":
		if SessionManager.current_save.name_number_on == true:
			SessionManager.current_save.name_number_on = false
			SaveManager.save_game(SessionManager.current_save)
			name_number_button.text = "Benenne die Zahl: aus"
		else:
			SessionManager.current_save.name_number_on = true
			SaveManager.save_game(SessionManager.current_save)
			name_number_button.text = "Benenne die Zahl: an"


func _on_x_to_y_pressed() -> void:
	main_window.visible = false
	from_x_to_y_window.visible = true


func _change_language() -> void:
	var x: int = SessionManager.current_save.x
	var y: int = SessionManager.current_save.y
	
	if SessionManager.current_save.language_selected == "English":
		title.text = "Number Exercise"
		
		if SessionManager.current_save.octal2deci == true:
			octal_deci_button.text = "Octal -> Decimal"
		else:
			octal_deci_button.text = "Decimal -> Octal"
		
		if x == 0 and y == 0:
			x_to_y_button.text = "From X To Y"
		else:
			x_to_y_button.text = "From " + str(x) + " To " + str(y)
		
		life_button.text = "Life: " + str(SessionManager.current_save.life)
		
		if SessionManager.current_save.find_emphasis_on == true:
			emphasis_button.text = "Find Emphasis: on"
		else:
			emphasis_button.text = "Find Emphasis: off"
		
		if SessionManager.current_save.name_number_on == true:
			name_number_button.text = "Name The Number: on"
		else:
			name_number_button.text = "Name The Number: off"
		
		confirm_button.text = "Confirm"
		back_to_main_menu_button.text = "Back To Main Menu"
	elif SessionManager.current_save.language_selected == "Deutsch":
		title.text = "Übungsspiel"
		
		if SessionManager.current_save.octal2deci == true:
			octal_deci_button.text = "Oktal -> Dezimal"
		else:
			octal_deci_button.text = "Dezimal -> Oktal"
		
		if x == 0 and y == 0:
			x_to_y_button.text = "Von X bis Y"
		else:
			x_to_y_button.text = "Von " + str(x) + " bis " + str(y)
		
		life_button.text = "Leben: " + str(SessionManager.current_save.life)
		
		if SessionManager.current_save.find_emphasis_on == true:
			emphasis_button.text = "Finde die Betonung: an"
		else:
			emphasis_button.text = "Finde die Betonung: aus"
		
		if SessionManager.current_save.name_number_on == true:
			name_number_button.text = "Benenne die Zahl: an"
		else:
			name_number_button.text = "Benenne die Zahl: aus"
		
		confirm_button.text = "Bestätigen"
		back_to_main_menu_button.text = "Zurück zum Hauptmenü"


func _on_confirm_pressed() -> void:
	if SessionManager.current_save.x < SessionManager.current_save.y:
		get_tree().change_scene_to_file("res://Scenes/Number Exercise/number_exercise_game.tscn")


func _signal_change_octal_deci_button_text_emitted(text: String) -> void:
	octal_deci_button.text = text


func _input(event: InputEvent) -> void:
	if main_window.visible == true:
		if event.is_action_pressed("Enter"):
			_on_confirm_pressed()
