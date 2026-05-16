extends CenterContainer


signal selection_window_on()

@onready var main_menu: Control = $"."
@onready var selection_window: Control = $"../Selection Window"
@onready var settings_at_the_start: Control = $"../Settings at the Start"
@onready var settings_window: Control = $"../Settings Window"
@onready var start_button: Control = $PanelContainer/VBoxContainer/Start
@onready var settings_button: Control = $PanelContainer/VBoxContainer/Settings
@onready var quit_button: Control = $PanelContainer/VBoxContainer/Quit
@onready var ko_fi_button: Control = $"PanelContainer/VBoxContainer/Ko-Fi"
@onready var credits_button: Control = $PanelContainer/VBoxContainer/Credits

@onready var credits_window: Control = $"../Credits Window"
@onready var cw_title: Control = $"../Credits Window/PanelContainer/VBoxContainer/Title"
@onready var cw_tuna: Control = $"../Credits Window/PanelContainer/VBoxContainer/Tuna Fwumsyul"
@onready var cw_kofi: Control = $"../Credits Window/PanelContainer/VBoxContainer/Ko-Fi"
@onready var cw_licence: Control = $"../Credits Window/PanelContainer/VBoxContainer/Licence"
@onready var cw_back_button: Control = $"../Credits Window/PanelContainer/VBoxContainer/Back"


func _ready() -> void:
	if SessionManager.current_save.new_game == true:
		settings_at_the_start.visible = true
	else:
		_change_language()
		main_menu.visible = true
		


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_start_pressed() -> void:
	main_menu.visible = false
	selection_window_on.emit()
	selection_window.visible = true


func _on_settings_pressed() -> void:
	main_menu.visible = false
	settings_window.visible = true

func _change_language() -> void:
	if SessionManager.current_save.language_selected == "English":
		start_button.text = "Start"
		settings_button.text = "Settings"
		ko_fi_button.text = "Donation (Ko-Fi)"
		credits_button.text = "Credits"
		quit_button.text = "Quit"
		
		cw_title.text = "Credits"
		cw_tuna.text = "Programmer: Tuna Fwumsyul aka Roter Lotus"
		cw_kofi.text = "Ko-Fi: www.ko-fi.com/roter_lotus"
		cw_licence.text = "This programm is free an open-source (git-hub)"
		cw_back_button.text = "Back"
		
	elif SessionManager.current_save.language_selected == "Deutsch":
		start_button.text = "Start"
		settings_button.text = "Einstellungen"
		ko_fi_button.text = "Spenden (Ko-Fi)"
		credits_button.text = "Credits"
		quit_button.text = "Beenden"
		
		cw_title.text = "Credits"
		cw_tuna.text = "Programmierer: Tuna Fwumsyul alias Roter Lotus"
		cw_kofi.text = "Ko-Fi: www.ko-fi.com/roter_lotus"
		cw_licence.text = "Dieses Programm ist kostenlos und open-source (git-hub)"
		cw_back_button.text = "Zurück"


func _signal_settings_window_back_button_emitted() -> void:
	_change_language()


func _on_ko_fi_pressed() -> void:
	OS.shell_open("https://ko-fi.com/roter_lotus")


func _on_credits_pressed() -> void:
	main_menu.visible = false
	credits_window.visible = true


func _on_credits_window_back_button() -> void:
	main_menu.visible = true
	credits_window.visible = false


func _on_git_hub_pressed() -> void:
	OS.shell_open("https://github.com/Depdiv/Ayholpxay")


func _signal_start_settings_done_emitted() -> void:
	_change_language()
