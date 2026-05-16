extends CenterContainer


signal settings_window_back_button()

@onready var settings_window: Control = $"."
@onready var main_menu: Control = $"../Main Menu"
@onready var title: Control = $PanelContainer/VBoxContainer/Title
@onready var language_button: Control = $PanelContainer/VBoxContainer/Language
@onready var octal_sign_button: Control = $"PanelContainer/VBoxContainer/Octal Sign"
@onready var separation_sign_button: Control = $"PanelContainer/VBoxContainer/Separation Sign"
@onready var back_button: Control = $PanelContainer/VBoxContainer/Back


func _ready() -> void:
	_change_language()

func _on_back_pressed() -> void:
	settings_window.visible = false
	settings_window_back_button.emit()
	main_menu.visible = true


func _change_language() -> void:
	if SessionManager.current_save.language_selected == "English":
		title.text = "Settings"
		language_button.text = "English"
		octal_sign_button.text = "Octal Sign: (" + SessionManager.current_save.octal_sign + ")"
		separation_sign_button.text = "Separation Sign: (" + SessionManager.current_save.separation_sign + ")"
		back_button.text = "Back"
	elif SessionManager.current_save.language_selected == "Deutsch":
		title.text = "Einstellungen"
		language_button.text = "Deutsch"
		octal_sign_button.text = "Oktalzeichen: (" + SessionManager.current_save.octal_sign + ")"
		separation_sign_button.text = "Trennungszeichen: (" + SessionManager.current_save.separation_sign + ")"
		back_button.text = "Zurück"


func _update_octal_sign() -> void:
	if SessionManager.current_save.octal_sign == "°":
		SessionManager.current_save.octal_sign = "0"
		SaveManager.save_game(SessionManager.current_save)
		
		if SessionManager.current_save.language_selected == "English":
			octal_sign_button.text = "Octal Sign: (" + SessionManager.current_save.octal_sign + ")"
		elif SessionManager.current_save.language_selected == "Deutsch":
			octal_sign_button.text = "Oktalzeichen: (" + SessionManager.current_save.octal_sign + ")"


func _update_separation_sign() -> void:
	if SessionManager.current_save.separation_sign == ",":
		SessionManager.current_save.separation_sign = "."
		SaveManager.save_game(SessionManager.current_save)
		
		if SessionManager.current_save.language_selected == "English":
			separation_sign_button.text = "Separation Sign: (" + SessionManager.current_save.separation_sign + ")"
		elif SessionManager.current_save.language_selected == "Deutsch":
			separation_sign_button.text = "Trennungszeichen: (" + SessionManager.current_save.separation_sign + ")"


func _signal_settings_window_on_emitted() -> void:
	_change_language()


func _on_language_pressed() -> void:
	if SessionManager.current_save.language_selected == "English":
		SessionManager.current_save.language_selected = "Deutsch"
		SaveManager.save_game(SessionManager.current_save)
		_change_language()
	elif SessionManager.current_save.language_selected == "Deutsch":
		SessionManager.current_save.language_selected = "English"
		SaveManager.save_game(SessionManager.current_save)
		_change_language()


func _on_octal_sign_pressed() -> void:
	if SessionManager.current_save.octal_sign == "°":
		SessionManager.current_save.octal_sign = "0"
		SaveManager.save_game(SessionManager.current_save)
		_update_octal_sign_button()
	else:
		SessionManager.current_save.octal_sign = "°"
		SaveManager.save_game(SessionManager.current_save)
		_update_octal_sign_button()
func _update_octal_sign_button() -> void:
	if SessionManager.current_save.language_selected == "English":
		octal_sign_button.text = "Octal Sign: (" + SessionManager.current_save.octal_sign + ")"
	elif SessionManager.current_save.language_selected == "Deutsch":
		octal_sign_button.text = "Oktalzeichen: (" + SessionManager.current_save.octal_sign + ")"


func _on_separation_sign_pressed() -> void:
	if SessionManager.current_save.separation_sign == ",":
		SessionManager.current_save.separation_sign = "."
		SaveManager.save_game(SessionManager.current_save)
		_update_separation_sign_button()
	else:
		SessionManager.current_save.separation_sign = ","
		SaveManager.save_game(SessionManager.current_save)
		_update_separation_sign_button()
func _update_separation_sign_button() -> void:
	if SessionManager.current_save.language_selected == "English":
		separation_sign_button.text = "Separation Sign: (" + SessionManager.current_save.separation_sign + ")"
	elif SessionManager.current_save.language_selected == "Deutsch":
		separation_sign_button.text = "Tennungszeichen: (" + SessionManager.current_save.separation_sign + ")"


func _signal_start_settings_done_emitted() -> void:
	_change_language()
