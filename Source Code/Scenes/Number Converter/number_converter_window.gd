extends CenterContainer


@onready var title: Control = $PanelContainer/VBoxContainer/Title
@onready var input: Control = $PanelContainer/VBoxContainer/Input
@onready var deci_octal_button: Control = $"PanelContainer/VBoxContainer/DeciOctal Button"
@onready var confirm_button: Control = $PanelContainer/VBoxContainer/Confirm
@onready var converted_num: Control = $"PanelContainer/VBoxContainer/Converted Number"
@onready var octal_as_text: Control = $"PanelContainer/VBoxContainer/Octal as Text"
@onready var emphasis: Control = $PanelContainer/VBoxContainer/Emphasis
@onready var back_to_main_menu: Control = $"Control/Back To Main Menu"
@onready var version: Control = $"../Version"

const HIGHEST_KNOWN_OCTAL_NUM: int = 77_777
const MAX_INPUT_LENGTH: int = 12

var octal_num: int
var deci_num: int


func _ready() -> void:
	_change_language()
	
	version.text = SessionManager.current_save.current_version


func _on_deci_octal_button_pressed() -> void:
	if SessionManager.current_save.int_is_octal == true:
		SessionManager.current_save.int_is_octal = false
		SaveManager.save_game(SessionManager.current_save)
		input.text = _remove_first_char(input.text)
		
		if SessionManager.current_save.language_selected == "English":
			deci_octal_button.text = "Decimal -> Octal"
		elif SessionManager.current_save.language_selected == "Deutsch":
			deci_octal_button.text = "Dezimal -> Oktal"
	else:
		var is_eigth_or_nine_in_num: bool = false
		
		for i: String in input.text:
			if int(i) == 8 or int(i) == 9:
				is_eigth_or_nine_in_num = true
				break
		
		if is_eigth_or_nine_in_num == false:
			SessionManager.current_save.int_is_octal = true
			input.text = SessionManager.current_save.octal_sign + input.text
			
			if SessionManager.current_save.language_selected == "English":
				deci_octal_button.text = "Octal -> Decimal"
			elif SessionManager.current_save.language_selected == "Deutsch":
				deci_octal_button.text = "Oktal -> Dezimal"


func _enter_pressed() -> void:
	if SessionManager.current_save.int_is_octal == true:
		octal_num = int(_remove_first_char(input.text))
		deci_num = NumFuncs.octal_into_deci(octal_num)
		var octal_num_as_text: String = NumFuncs.octal_num_into_text(str(octal_num))
		converted_num.text = SessionManager.current_save.octal_sign + NumFuncs.add_commata(octal_num) + " -> " + NumFuncs.add_commata(deci_num)
				
		if octal_num > HIGHEST_KNOWN_OCTAL_NUM:
			if SessionManager.current_save.language_selected == "English":
				octal_as_text.text = "There is no official name for numbers greater than " + SessionManager.current_save.octal_sign + "77" + SessionManager.current_save.separation_sign + "777 yet!"
				emphasis.text = "-"
			elif SessionManager.current_save.language_selected == "Deutsch":
				octal_as_text.text = "Es gibt noch keine offizielle Bezeichnung für Zahlen, \ndie höher sind als " + SessionManager.current_save.octal_sign + "77" + SessionManager.current_save.separation_sign + "777!"
				emphasis.text = "-"
		else:
			octal_as_text.text = NumFuncs.octal_num_into_text(str(octal_num))
			emphasis.text = NumFuncs.display_syllables(NumFuncs.find_emphasis(octal_num_as_text, octal_num))
		
		input.text = "°"
	else:
		deci_num = int(input.text)
		octal_num = NumFuncs.deci_into_octal(deci_num)
		var octal_num_as_text: String = NumFuncs.octal_num_into_text(str(octal_num))
		converted_num.text = NumFuncs.add_commata(deci_num) + " -> " + SessionManager.current_save.octal_sign + NumFuncs.add_commata(octal_num)
		
		if octal_num > HIGHEST_KNOWN_OCTAL_NUM:
			if SessionManager.current_save.language_selected == "English":
				octal_as_text.text = "There is no official name for numbers greater than " + SessionManager.current_save.octal_sign + "77" + SessionManager.current_save.separation_sign + "777 yet!"
				emphasis.text = "-"
			elif SessionManager.current_save.language_selected == "Deutsch":
				octal_as_text.text = "Es gibt noch keine offizielle Bezeichnung für Zahlen, \ndie höher sind als " + SessionManager.current_save.octal_sign + "77" + SessionManager.current_save.separation_sign + "777!"
				emphasis.text = "-"
		else:
			octal_as_text.text = NumFuncs.octal_num_into_text(str(octal_num))
			emphasis.text = NumFuncs.display_syllables(NumFuncs.find_emphasis(octal_num_as_text, octal_num))
		
		input.text = ""
func _on_confirm_pressed() -> void:
	_enter_pressed()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Enter"):
		_enter_pressed()
	elif event.is_action_pressed("OctalDeci"):
		if SessionManager.current_save.int_is_octal == true:
			SessionManager.current_save.int_is_octal = false
			SaveManager.save_game(SessionManager.current_save)
			input.text = _remove_first_char(input.text)
			
			if SessionManager.current_save.language_selected == "English":
				deci_octal_button.text = "Decimal -> Octal"
			elif SessionManager.current_save.language_selected == "Deutsch":
				deci_octal_button.text = "Dezimal -> Oktal"
		else:
			var is_eigth_or_nine_in_num: bool = false
			
			for i: String in input.text:
				if int(i) == 8 or int(i) == 9:
					is_eigth_or_nine_in_num = true
					break
			
			if is_eigth_or_nine_in_num == false:
				SessionManager.current_save.int_is_octal = true
				SaveManager.save_game(SessionManager.current_save)
				input.text = "°" + input.text
				
				if SessionManager.current_save.language_selected == "English":
					deci_octal_button.text = "Octal -> Decimal"
				elif SessionManager.current_save.language_selected == "Deutsch":
					deci_octal_button.text = "Oktal -> Dezimal"
	elif event.is_action_pressed("Backspace"):
		if SessionManager.current_save.int_is_octal == false:
			input.text = input.text.left(-1)
		else:
			if input.text.length() > 1:
				input.text = input.text.left(-1)
	elif event.is_action_pressed("0"):
		if input.text.length() < MAX_INPUT_LENGTH:
			input.text += "0"
	elif event.is_action_pressed("1"):
		if input.text.length() < MAX_INPUT_LENGTH:
			input.text += "1"
	elif event.is_action_pressed("2"):
		if input.text.length() < MAX_INPUT_LENGTH:
			input.text += "2"
	elif event.is_action_pressed("3"):
		if input.text.length() < MAX_INPUT_LENGTH:
			input.text += "3"
	elif event.is_action_pressed("4"):
		if input.text.length() < MAX_INPUT_LENGTH:
			input.text += "4"
	elif event.is_action_pressed("5"):
		if input.text.length() < MAX_INPUT_LENGTH:
			input.text += "5"
	elif event.is_action_pressed("6"):
		if input.text.length() < MAX_INPUT_LENGTH:
			input.text += "6"
	elif event.is_action_pressed("7"):
		if input.text.length() < MAX_INPUT_LENGTH:
			input.text += "7"
	elif event.is_action_pressed("8"):
		if SessionManager.current_save.int_is_octal == false:
			if input.text.length() < MAX_INPUT_LENGTH:
				input.text += "8"
	elif event.is_action_pressed("9"):
		if SessionManager.current_save.int_is_octal == false:
			if input.text.length() < MAX_INPUT_LENGTH:
				input.text += "9"


func _remove_first_char(text: String) -> String:
	var result: String
	
	result = text.reverse()
	result = result.left(-1)
	result = result.reverse()
	
	return result


func _on_back_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main Menu/main.tscn")


func _change_language() -> void:
	if SessionManager.current_save.language_selected == "English":
		title.text = "Number Converter"
		
		if SessionManager.current_save.int_is_octal == true:
			input.text = SessionManager.current_save.octal_sign
			deci_octal_button.text = "Octal -> Decimal"
		else:
			input.text = ""
			deci_octal_button.text = "Decimal -> Octal"
		
		confirm_button.text = "Confirm"
		back_to_main_menu.text = "Back To Main Menu"
	elif SessionManager.current_save.language_selected == "Deutsch":
		title.text = "Zahlenumrechner"
		
		if SessionManager.current_save.int_is_octal == true:
			input.text = SessionManager.current_save.octal_sign
			deci_octal_button.text = "Oktal -> Dezimal"
		else:
			input.text = ""
			deci_octal_button.text = "Dezimal -> Oktal"
		
		confirm_button.text = "Bestätigen"
		back_to_main_menu.text = "Zurück zum Hauptmenü"
