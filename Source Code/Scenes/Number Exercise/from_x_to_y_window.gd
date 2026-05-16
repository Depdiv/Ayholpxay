extends CenterContainer


signal change_octal_deci_button_text(text: String)

@onready var main_window: Control = $"../Main Window"
@onready var from_x_to_y_window: Control = $"."
@onready var x_error: Control = $"PanelContainer/VBoxContainer/X Error"
@onready var y_error: Control = $"PanelContainer/VBoxContainer/Y Error"
@onready var x_to_y_button: Control = $"../Main Window/PanelContainer/VBoxContainer/X To Y"
@onready var x_line: Control = $PanelContainer/VBoxContainer/X
@onready var y_line: Control =$PanelContainer/VBoxContainer/Y
@onready var title: Control = $PanelContainer/VBoxContainer/Title
@onready var x_to_y_button_on_main_window: Control = $"../Main Window/PanelContainer/VBoxContainer/X To Y"
@onready var confirm_button: Control = $PanelContainer/VBoxContainer/Confirm
@onready var back_button: Control = $PanelContainer/VBoxContainer/Back

var octal_sign: String = SessionManager.current_save.octal_sign


func _ready() -> void:
	_change_language()



func _on_back_pressed() -> void:
	from_x_to_y_window.visible = false
	main_window.visible = true


func _on_x_text_changed(new_text: String) -> void:
	if SessionManager.current_save.octal2deci == true:
		var eight_or_nine_found: bool = false
		
		for i: String in new_text:
			if i == "8" or i == "9":
				eight_or_nine_found = true
				break
		
		if eight_or_nine_found == true:
			if SessionManager.current_save.language_selected == "English":
				x_error.text = "Invalid Input!\nOctal numbers can't contain 8 or 9!"
			elif SessionManager.current_save.language_selected == "Deutsch":
				x_error.text = "Ungültige Eingabe!\nOktalzahlen können keine 8 oder 9 haben!"
			x_error.visible = true
		elif new_text.is_valid_int() == true:
			x_error.visible = false
		else:
			if SessionManager.current_save.language_selected == "English":
				x_error.text = "Invalid Input!\nOnly numbers are allowed!"
			elif SessionManager.current_save.language_selected == "Deutsch":
				x_error.text = "Ungültige Eingabe!\nNur Zahlen sind erlaubt!"
			x_error.visible = true
	else:
		if new_text.is_valid_int() == true:
			x_error.visible = false
		else:
			if SessionManager.current_save.language_selected == "English":
				x_error.text = "Invalid Input!\nOnly numbers are allowed!"
			elif SessionManager.current_save.language_selected == "Deutsch":
				x_error.text = "Ungültige Eingabe!\nNur Zahlen sind erlaubt!"
			x_error.visible = true


func _on_y_text_changed(new_text: String) -> void:
	if SessionManager.current_save.octal2deci == true:
		var eight_or_nine_found: bool = false
		
		for i: String in new_text:
			if i == "8" or i == "9":
				eight_or_nine_found = true
				break
		
		if eight_or_nine_found == true:
			if SessionManager.current_save.language_selected == "English":
				y_error.text = "Invalid Input!\nOctal numbers can't contain 8 or 9!"
			elif SessionManager.current_save.language_selected == "Deutsch":
				y_error.text = "Ungültige Eingabe!\nOktalzahlen können keine 8 oder 9 haben!"
			y_error.visible = true
		elif new_text.is_valid_int() == true:
			y_error.visible = false
		else:
			if SessionManager.current_save.language_selected == "English":
				y_error.text = "Invalid Input!\nOnly Numbers are allowed!"
			elif SessionManager.current_save.language_selected == "Deutsch":
				y_error.text = "Ungültige Eingabe!\nNur Zahlen sind erlaubt!"
			y_error.visible = true
	else:
		if new_text.is_valid_int() == true:
			y_error.visible = false
		else:
			if SessionManager.current_save.language_selected == "English":
				y_error.text = "Invalid Input!\nOnly Numbers are allowed!"
			elif SessionManager.current_save.language_selected == "Deutsch":
				y_error.text = "Ungültige Eingabe!\nNur Zahlen sind erlaubt!"
			y_error.visible = true


func _on_confirm_pressed() -> void:
	if x_error.visible == false and y_error.visible == false:
		if x_line.text.is_valid_int() == true and y_line.text.is_valid_int() == true:
			if int(x_line.text) < int(y_line.text):
				SessionManager.current_save.x = int(x_line.text)
				SessionManager.current_save.y = int(y_line.text)
				var x: int = SessionManager.current_save.x
				var y: int = SessionManager.current_save.y
				
				SaveManager.save_game(SessionManager.current_save)
				
				if SessionManager.current_save.language_selected == "English":
					if SessionManager.current_save.octal2deci == true:
						title.text = "From " + octal_sign + NumFuncs.add_commata(x) + " To " + octal_sign + NumFuncs.add_commata(y)
						x_to_y_button_on_main_window.text = "From " + octal_sign + NumFuncs.add_commata(x) + " To " + octal_sign + NumFuncs.add_commata(y)
					else:
						title.text = "From " + NumFuncs.add_commata(x) + " To " + NumFuncs.add_commata(y)
						x_to_y_button_on_main_window.text = "From " + NumFuncs.add_commata(x) + " To " + NumFuncs.add_commata(y)
				elif SessionManager.current_save.language_selected == "Deutsch":
					if SessionManager.current_save.octal2deci == true:
						title.text = "Von " + octal_sign + NumFuncs.add_commata(x) + " bis " + octal_sign + NumFuncs.add_commata(y)
						x_to_y_button_on_main_window.text = "Von " + octal_sign + NumFuncs.add_commata(x)+ " To " + octal_sign + NumFuncs.add_commata(y)
					else:
						title.text = "Von " + NumFuncs.add_commata(x) + " bis " + NumFuncs.add_commata(y)
						x_to_y_button_on_main_window.text = "Von " + NumFuncs.add_commata(x) + " bis " + NumFuncs.add_commata(y)
			else:
				if SessionManager.current_save.language_selected == "English":
					x_error.text = "Invalid Input!\nX has to be smaller then Y!"
				elif SessionManager.current_save.language_selected == "Deutsch":
					x_error.text = "Ungültige Eingabe!\nX muss größer als Y sein!"
				x_error.visible = true

func _change_language() -> void:
	var x: int = SessionManager.current_save.x
	var y: int = SessionManager.current_save.y
	
	if SessionManager.current_save.language_selected == "English":
		if SessionManager.current_save.x == 0 and SessionManager.current_save.y == 0:
			if SessionManager.current_save.octal2deci == true:
				title.text = "From " + octal_sign + "X" + " To " + octal_sign + "Y" 
				x_to_y_button_on_main_window.text = "From " + octal_sign + "X" + " To " + octal_sign + "Y" 
			else:
				title.text = "From X To Y"
				x_to_y_button_on_main_window.text = "From X To Y"
		else:
			if SessionManager.current_save.octal2deci == true:
				title.text = "From " + octal_sign + NumFuncs.add_commata(x) + " To " + octal_sign + NumFuncs.add_commata(y)
				x_to_y_button_on_main_window.text = "From " + octal_sign + NumFuncs.add_commata(x) + " To " + octal_sign + NumFuncs.add_commata(y)
			else:
				title.text = "From " + NumFuncs.add_commata(x) + " To " + NumFuncs.add_commata(y)
				x_to_y_button_on_main_window.text = "From " + NumFuncs.add_commata(x) + " To " + NumFuncs.add_commata(y)
		
		x_error.text = "Invalid Input!\nOnly Numbers are allowed!"
		y_error.text = "Invalid Input!\nOnly Numbers are allowed!"
		confirm_button.text = "Confirm"
		back_button.text = "Back"
	elif SessionManager.current_save.language_selected == "Deutsch":
		if SessionManager.current_save.x == 0 and SessionManager.current_save.y == 0:
			if SessionManager.current_save.octal2deci == true:
				title.text = "Von " + octal_sign + "X" + " bis " + octal_sign + "Y" 
				x_to_y_button_on_main_window.text = "Von " + octal_sign + "X" + " bis " + octal_sign + "Y" 
			else:
				title.text = "Von X bis Y"
				x_to_y_button_on_main_window.text = "Von X bis Y"
		else:
			if SessionManager.current_save.octal2deci == true:
				title.text = "Von " + octal_sign + NumFuncs.add_commata(x) + " bis " + octal_sign + NumFuncs.add_commata(y)
				x_to_y_button_on_main_window.text = "Von " + octal_sign + NumFuncs.add_commata(x) + " bis " + octal_sign + NumFuncs.add_commata(y)
			else:
				title.text = "Von " + NumFuncs.add_commata(x) + " bis " + NumFuncs.add_commata(y)
				x_to_y_button_on_main_window.text = "Von " + NumFuncs.add_commata(x) + " bis " + NumFuncs.add_commata(y)
		
		x_error.text = "Ungültige Eingabe!\nNur Zahlen sind erlaubt!"
		y_error.text = "Ungültige Eingabe!\nNur Zahlen sind erlaubt!"
		confirm_button.text = "Bestätigen"
		back_button.text = "Zurück"


func _signal_octal_deci_button_pressed_emitted() -> void:
	var x: int = SessionManager.current_save.x
	var y: int = SessionManager.current_save.y
	
	if SessionManager.current_save.octal2deci == true:
		if SessionManager.current_save.language_selected == "English":
			if SessionManager.current_save.x == 0 and SessionManager.current_save.y == 0:
				title.text = "From " + octal_sign + "X" + " To " + octal_sign + "Y" 
				x_to_y_button_on_main_window.text = "From " + octal_sign + "X" + " To " + octal_sign + "Y" 
				change_octal_deci_button_text.emit("Octal -> Decimal")
			else:
				title.text = "From " + octal_sign + NumFuncs.add_commata(x) + " To " + octal_sign + NumFuncs.add_commata(y)
				x_to_y_button_on_main_window.text = "From " + octal_sign + NumFuncs.add_commata(x)+ " To " + octal_sign + NumFuncs.add_commata(y)
				change_octal_deci_button_text.emit("Octal -> Decimal")
		elif SessionManager.current_save.language_selected == "Deutsch":
			if SessionManager.current_save.x == 0 and SessionManager.current_save.y == 0:
				title.text = "Von " + octal_sign + "X" + " bis " + octal_sign + "Y" 
				x_to_y_button_on_main_window.text = "Von " + octal_sign + "X" + " bis " + octal_sign + "Y" 
				change_octal_deci_button_text.emit("Oktal -> Dezimal")
			else:
				title.text = "Von " + octal_sign + NumFuncs.add_commata(x) + " bis " + octal_sign + NumFuncs.add_commata(y)
				x_to_y_button_on_main_window.text = "Von " + octal_sign + NumFuncs.add_commata(x) + " bis " + octal_sign + NumFuncs.add_commata(y)
				change_octal_deci_button_text.emit("Oktal -> Dezimal")
	else:
		if SessionManager.current_save.language_selected == "English":
			if SessionManager.current_save.x == 0 and SessionManager.current_save.y == 0:
				title.text = "From X To Y"
				x_to_y_button_on_main_window.text = "From X To Y"
				change_octal_deci_button_text.emit("Decimal -> Octal")
			else:
				title.text = "From " + NumFuncs.add_commata(x) + " To " + NumFuncs.add_commata(y)
				x_to_y_button_on_main_window.text = "From " + NumFuncs.add_commata(x) + " To " + NumFuncs.add_commata(y)
				change_octal_deci_button_text.emit("Decimal -> Octal")
		elif SessionManager.current_save.language_selected == "Deutsch":
			if SessionManager.current_save.x == 0 and SessionManager.current_save.y == 0:
				title.text = "Von X bis Y"
				x_to_y_button_on_main_window.text = "Von X bis Y"
				change_octal_deci_button_text.emit("Dezimal -> Oktal")
			else:
				title.text = "Von " + NumFuncs.add_commata(x) + " bis " + NumFuncs.add_commata(y)
				x_to_y_button_on_main_window.text = "Von " + NumFuncs.add_commata(x) + " bis " + NumFuncs.add_commata(y)
				change_octal_deci_button_text.emit("Dezimal -> Oktal")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Enter"):
		if from_x_to_y_window.visible == true:
			_on_confirm_pressed()
