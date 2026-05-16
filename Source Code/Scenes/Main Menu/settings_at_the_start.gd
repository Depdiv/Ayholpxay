extends CenterContainer


signal start_settings_done()

@onready var title: Control = $PanelContainer/VBoxContainer/Title
@onready var language_button: Control = $PanelContainer/VBoxContainer/Language
@onready var octal_sign_button: Control = $"PanelContainer/VBoxContainer/Octal Sign"
@onready var separation_sign_button: Control = $"PanelContainer/VBoxContainer/Separation Sign"
@onready var confirm_button: Control = $PanelContainer/VBoxContainer/Confirm
@onready var settings_at_the_start: Control = $"."
@onready var main_menu: Control = $"../Main Menu"
@onready var version: Control = $"../Version"


func _ready() -> void:
	_change_language()
	
	version.text = SessionManager.current_save.current_version


func _on_language_pressed() -> void:
	if SessionManager.current_save.language_selected == "English":
		SessionManager.current_save.language_selected = "Deutsch"
		SaveManager.save_game(SessionManager.current_save)
		_change_language()
	else:
		SessionManager.current_save.language_selected = "English"
		SaveManager.save_game(SessionManager.current_save)
		_change_language()
func _change_language() -> void:
	if SessionManager.current_save.language_selected == "English":
		title.text = "Settings"
		language_button.text = "English"
		octal_sign_button.text = "Octal Sign: (" + SessionManager.current_save.octal_sign + ")"
		separation_sign_button.text = "Separation Sign: (" + SessionManager.current_save.separation_sign + ")"
		confirm_button.text = "Confirm"
	elif SessionManager.current_save.language_selected == "Deutsch":
		title.text = "Einstellungen"
		language_button.text = "Deutsch"
		octal_sign_button.text = "Oktalzeichen: (" + SessionManager.current_save.octal_sign + ")"
		separation_sign_button.text = "Trennungszeichen: (" + SessionManager.current_save.separation_sign + ")"
		confirm_button.text = "Bestätigen"


func _on_octal_sign_pressed() -> void:
	if SessionManager.current_save.octal_sign == "°":
		SessionManager.current_save.octal_sign = "0"
	else:
		SessionManager.current_save.octal_sign = "°"
	SaveManager.save_game(SessionManager.current_save)
		
	if SessionManager.current_save.language_selected == "English":
		octal_sign_button.text = "Octal Sign: (" + SessionManager.current_save.octal_sign + ")"
	elif SessionManager.current_save.language_selected == "Deutsch":
		octal_sign_button.text = "Oktalzeichen: (" + SessionManager.current_save.octal_sign + ")"


func _on_separation_sign_pressed() -> void:
	if SessionManager.current_save.separation_sign == ",":
		SessionManager.current_save.separation_sign = "."
	else:
		SessionManager.current_save.separation_sign = ","
	SaveManager.save_game(SessionManager.current_save)
	
	if SessionManager.current_save.language_selected == "English":
		separation_sign_button.text = "Separation Sign: (" + SessionManager.current_save.separation_sign + ")"
	elif SessionManager.current_save.language_selected == "Deutsch":
		separation_sign_button.text = "Tennungszeichen: (" + SessionManager.current_save.separation_sign + ")"


func _on_confirm_pressed() -> void:
	SessionManager.current_save.new_game = false
	SaveManager.save_game(SessionManager.current_save)
	settings_at_the_start.visible = false
	start_settings_done.emit()
	main_menu.visible = true
