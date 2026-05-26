extends CenterContainer


signal dead(score: int)

@onready var title: Control = $PanelContainer/VBoxContainer/Title
@onready var life: Control = $PanelContainer/VBoxContainer/Life
@onready var score: Control = $PanelContainer/VBoxContainer/Score
@onready var number_in_q: Control = $"PanelContainer/VBoxContainer/Number In Question"
@onready var instruction: Control = $PanelContainer/VBoxContainer/Instruction
@onready var input_number: Control = $"PanelContainer/VBoxContainer/Input Number"
@onready var input_name: Control = $"PanelContainer/VBoxContainer/Input Name"
@onready var where_emphasis: Control = $"PanelContainer/VBoxContainer/Where Is The Emphasis"
@onready var confirm_button: Control = $PanelContainer/VBoxContainer/Confirm
@onready var back_button: Control = $"../Back To Main Menu"
@onready var input_num_error: Control = $"PanelContainer/VBoxContainer/Input Number Error"
@onready var hbox_emphasis: Control = $"PanelContainer/VBoxContainer/HBox Emphasis"
@onready var game_over_window: Control = $"../Game Over"
@onready var main_window: Control = $"."

@onready var answer_window: Control = $"../Answer Window"
@onready var correct_label: Control = $"../Answer Window/PanelContainer/VBoxContainer/Correct?"
@onready var text_label: Control = $"../Answer Window/PanelContainer/VBoxContainer/Text"
@onready var answer_label: Control = $"../Answer Window/PanelContainer/VBoxContainer/Answer"

@onready var version: Control = $"../Version"

var current_score: int = 0
var current_life: int = SessionManager.current_save.life
var octal_num: int = 0
var deci_num: int = 0
var octal_as_text: String = ""
var octal_syllables: Array[String]
var emphasis_at: int = 0
var one_time_bool: bool = true
var find_emphasis: bool = SessionManager.current_save.find_emphasis_on
var name_number: bool = SessionManager.current_save.name_number_on
var language_selected: String = SessionManager.current_save.language_selected
var octal_sign: String = SessionManager.current_save.octal_sign

var syllable_scene: PackedScene = preload("res://Scenes/Number Exercise/syllable.tscn")

const HIGHEST_KNOWN_OCTAL_NUM: int = 77_777


func _ready() -> void:
	randomize()
	_change_language()
	
	new_round()
	
	input_number.visible = true
	
	version.text = SessionManager.current_save.current_version

func _change_language() -> void:
	if SessionManager.current_save.language_selected == "English":
		title.text = "Number Exercise"
		life.text = "Life: " + str(SessionManager.current_save.life)
		score.text = "Score: " + str(current_score)
		
		if SessionManager.current_save.octal2deci == true:
			instruction.text = "Enter a decimal number."
		else:
			instruction.text = "Enter an octal number."
		
		where_emphasis.text = "Which syllable is the stress on?"
		confirm_button.text = "Confirm"
		back_button.text = "Back To Main Menu"
	elif SessionManager.current_save.language_selected == "Deutsch":
		title.text = "Übungsspiel"
		life.text = "Leben: " + str(SessionManager.current_save.life)
		score.text = "Score: " + str(current_score)
		
		if SessionManager.current_save.octal2deci == true:
			instruction.text = "Geben Sie eine Dezimalzahl ein."
		else:
			instruction.text = "Geben Sie eine Oktalzahl ein."
		
		where_emphasis.text = "Auf welcher Silbe befindet sich die Betonung?"
		confirm_button.text = "Bestätigen"
		back_button.text = "Zurück zum Hauptmenü"


func _on_back_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main Menu/main.tscn")


func pick_new_number() -> int:
	var result: int = 0
	var x: int = SessionManager.current_save.x
	var y: int = SessionManager.current_save.y
	
	if SessionManager.current_save.octal2deci == true:
		var x_deci: int = NumFuncs.octal_into_deci(x)
		var y_deci: int = NumFuncs.octal_into_deci(y)
		var decimal_number: int = randi_range(x_deci, y_deci)
		
		var octal_string: String = "%o" % decimal_number
		
		result = int(octal_string)
	else:
		result = randi_range(x, y)
	
	return result


func new_round() -> void:
	if SessionManager.current_save.octal2deci == true:
		octal_num = pick_new_number()
		number_in_q.text = octal_sign + NumFuncs.add_commata(octal_num) + "?"
		deci_num = NumFuncs.octal_into_deci(octal_num)
		one_time_bool = true
		input_number.text = ""
		input_number.visible = true
		
		if find_emphasis == true:
			hbox_emphasis.visible = false
			remove_all_syllable_buttons()
			octal_as_text = NumFuncs.octal_num_into_text(str(octal_num))
			octal_syllables = NumFuncs.find_emphasis(octal_as_text, octal_num)
			
			for i: int in octal_syllables.size():
				if octal_syllables[i] == octal_syllables[i].to_upper():
					emphasis_at = i
		
		if name_number == true:
			input_name.visible = false
			input_name.text = ""
			octal_as_text = NumFuncs.octal_num_into_text(str(octal_num))
	else:
		deci_num = pick_new_number()
		number_in_q.text = NumFuncs.add_commata(deci_num) + "?"
		octal_num = NumFuncs.deci_into_octal(deci_num)
		one_time_bool = true
		input_number.text = ""
		input_number.visible = true
		
		if find_emphasis == true:
			hbox_emphasis.visible = false
			octal_as_text = NumFuncs.octal_num_into_text(str(octal_num))
			octal_syllables = NumFuncs.find_emphasis(octal_as_text, octal_num)
			
			for i: int in octal_syllables.size():
				if octal_syllables[i] == octal_syllables[i].to_upper():
					emphasis_at = i
		if name_number == true:
			input_name.visible = false
			octal_as_text = NumFuncs.octal_num_into_text(str(octal_num))
	
	if language_selected == "English":
		if SessionManager.current_save.octal2deci == true:
			instruction.text = "Enter a decimal number."
		else:
			instruction.text = "Enter an octal number."
	elif language_selected == "Deutsch":
		if SessionManager.current_save.octal2deci == true:
			instruction.text = "Geben Sie eine Dezimalzahl ein."
		else:
			instruction.text = "Geben Sie eine Oktalzahl ein."
func _input_number() -> void:
	if input_number.visible == true:
		if SessionManager.current_save.octal2deci == true:
			if int(input_number.text) == deci_num and input_number.text.is_empty() == false:
				current_score += 1
				
				if language_selected == "English":
					score.text = "Score: " + NumFuncs.add_commata(current_score)
					
					correct_label.text = "Correct!"
					text_label.text = "The Answer:"
					answer_label.text = str(deci_num)
					answer_window.visible = true
				elif language_selected == "Deutsch":
					score.text = "Score: " + NumFuncs.add_commata(current_score)
					
					correct_label.text = "Richtig!"
					text_label.text = "Die Antwort:"
					answer_label.text = str(deci_num)
					answer_window.visible = true
			else:
				if current_life - 1 > 0:
					current_life -= 1
					
					one_time_bool = false
				else:
					main_window.visible = false
					dead.emit(current_score)
					game_over_window.visible = true
				
				if language_selected == "English":
					life.text = "Life: " + NumFuncs.add_commata(current_life)
					
					correct_label.text = "Wrong!"
					text_label.text = "The Answer:"
					answer_label.text = str(deci_num)
					answer_window.visible = true
				elif language_selected == "Deutsch":
					life.text = "Leben: " + NumFuncs.add_commata(current_life)
					
					correct_label.text = "Falsch!"
					text_label.text = "Die Antwort:"
					answer_label.text = str(deci_num)
					answer_window.visible = true
		else:
			if int(input_number.text) == octal_num:
				current_score += 1
				
				if language_selected == "English":
					score.text = "Score: " + NumFuncs.add_commata(current_score)
					
					correct_label.text = "Correct!"
					text_label.text = "The Answer:"
					answer_label.text = octal_sign + str(octal_num)
					answer_window.visible = true
				elif language_selected == "Deutsch":
					score.text = "Score: " + NumFuncs.add_commata(current_score)
					
					correct_label.text = "Richtig!"
					text_label.text = "Die Antwort:"
					answer_label.text = octal_sign + str(octal_num)
					answer_window.visible = true
			else:
				if current_life - 1 > 0:
					current_life -= 1
					
					if language_selected == "English":
						life.text = "Life: " + NumFuncs.add_commata(current_life)
						
						correct_label.text = "Wrong!"
						text_label.text = "The Answer:"
						answer_label.text = octal_sign + str(octal_num)
						answer_window.visible = true
					elif language_selected == "Deutsch":
						life.text = "Leben: " + NumFuncs.add_commata(current_life)
						
						correct_label.text = "Falsch!"
						text_label.text = "Die Antwort:"
						answer_label.text = octal_sign + str(octal_num)
						answer_window.visible = true
					
					one_time_bool = false
				else:
					main_window.visible = false
					dead.emit(current_score)
					game_over_window.visible = true
					
					if language_selected == "English":
						correct_label.text = "Wrong!"
						text_label.text = "The Answer:"
						answer_label.text = octal_sign + str(octal_num)
						answer_window.visible = true
					elif language_selected == "Deutsch":
						life.text = "Leben: " + NumFuncs.add_commata(current_life)
						
						correct_label.text = "Falsch!"
						text_label.text = "Die Antwort:"
						answer_label.text = octal_sign + str(octal_num)
						answer_window.visible = true
		
		input_number.visible = false
func _find_emphasis() -> void:
	if check_emphasis() == true:
		current_score += 1
		
		if language_selected == "English":
			score.text = "Score: " + NumFuncs.add_commata(current_score)
			
			correct_label.text = "Correct!"
			text_label.text = "The Answer:"
			answer_label.text = NumFuncs.display_syllables(NumFuncs.find_emphasis(octal_as_text, octal_num))
			answer_window.visible = true
		elif language_selected == "Deutsch":
			score.text = "Score: " + NumFuncs.add_commata(current_score)
			
			correct_label.text = "Richtig!"
			text_label.text = "Die Antwort:"
			answer_label.text = NumFuncs.display_syllables(NumFuncs.find_emphasis(octal_as_text, octal_num))
			answer_window.visible = true
	else:
		if one_time_bool == true:
			if current_life - 1 > 0:
				current_life -= 1
			else:
				main_window.visible = false
				dead.emit(current_score)
				game_over_window.visible = true
		
		if language_selected == "English":
			life.text = "Life: " + NumFuncs.add_commata(current_life)
			
			correct_label.text = "Wrong!"
			text_label.text = "The Answer:"
			answer_label.text = NumFuncs.display_syllables(NumFuncs.find_emphasis(octal_as_text, octal_num))
			answer_window.visible = true
		elif language_selected == "Deutsch":
			life.text = "Leben: " + NumFuncs.add_commata(current_life)
			
			correct_label.text = "Falsch!"
			text_label.text = "Die Antwort:"
			answer_label.text = NumFuncs.display_syllables(NumFuncs.find_emphasis(octal_as_text, octal_num))
			answer_window.visible = true
	remove_all_syllable_buttons()
func _name_number() -> void:
	if input_name.text == octal_as_text:
		current_score += 1
		
		if language_selected == "English":
			score.text = "Score: " + NumFuncs.add_commata(current_score)
			
			correct_label.text = "Correct!"
			text_label.text = "The Answer:"
			answer_label.text = octal_as_text
			answer_window.visible = true
		elif language_selected == "Deutsch":
			score.text = "Score: " + NumFuncs.add_commata(current_score)
			
			correct_label.text = "Richtig!"
			text_label.text = "Die Antwort:"
			answer_label.text = octal_as_text
			answer_window.visible = true
	else:
		if one_time_bool == true:
			if current_life - 1 > 0:
				current_life -= 1
			else:
				main_window.visible = false
				dead.emit(current_score)
				game_over_window.visible = true
		
		if language_selected == "English":
			life.text = "Life: " + NumFuncs.add_commata(current_life)
			
			correct_label.text = "Wrong!"
			text_label.text = "The Answer:"
			answer_label.text = octal_as_text
			answer_window.visible = true
		elif language_selected == "Deutsch":
			life.text = "Leben: " + NumFuncs.add_commata(current_life)
			
			correct_label.text = "Falsch!"
			text_label.text = "Die Antwort:"
			answer_label.text = octal_as_text
			answer_window.visible = true
	
	input_name.text = ""
func _on_confirm_pressed() -> void:
	if find_emphasis == false and name_number == false:
		_input_number()
			
		new_round()
	elif find_emphasis == true and name_number == false:
		if input_number.visible == true:
			_input_number()
			
			if octal_num <= HIGHEST_KNOWN_OCTAL_NUM:
				if language_selected == "English":
					instruction.text = "Click on the syllable that is stressed."
				elif language_selected == "Deutsch":
					instruction.text = "Klicken Sie auf die Silbe, wo die Betonung liegt."
			
				create_syllable_buttons()
				hbox_emphasis.visible = true
			else:
				new_round()
		else:
			_find_emphasis()
			
			new_round()
	elif find_emphasis == false and name_number == true:
		if input_number.visible == true:
			_input_number()
			
			if octal_num <= HIGHEST_KNOWN_OCTAL_NUM:
				if language_selected == "English":
					instruction.text = "Write the octal number " + octal_sign + NumFuncs.add_commata(octal_num) + " in Na'vi."
				elif language_selected == "Deutsch":
					instruction.text = "Schreiben Sie die Oktalzahl " + octal_sign + NumFuncs.add_commata(octal_num) + " auf Na'vi."
				
				input_name.visible = true
			else:
				new_round()
		else:
			_name_number()
			
			new_round()
	else:
		if input_number.visible == true:
			_input_number()
			
			if octal_num <= HIGHEST_KNOWN_OCTAL_NUM:
				if language_selected == "English":
					instruction.text = "Write the octal number " + octal_sign + NumFuncs.add_commata(octal_num) + " in Na'vi."
				elif language_selected == "Deutsch":
					instruction.text = "Schreiben Sie die Oktalzahl " + octal_sign + NumFuncs.add_commata(octal_num) + " auf Na'vi."
				
				input_name.visible = true
			else:
				new_round()
		elif input_name.visible == true:
			_name_number()
			
			if language_selected == "English":
				instruction.text = "Click on the syllable that is stressed."
			elif language_selected == "Deutsch":
				instruction.text = "Klicken Sie auf die Silbe, wo die Betonung liegt."
			
			input_name.visible = false
			create_syllable_buttons()
			hbox_emphasis.visible = true
		elif hbox_emphasis.visible == true:
			_find_emphasis()
			
			new_round()


func _on_input_number_text_changed(new_text: String) -> void:
	if SessionManager.current_save.octal2deci == false:
		var eight_or_nine_found: bool = false
		
		for i: String in new_text:
			if i == "8" or i == "9":
				eight_or_nine_found = true
				break
		
		if eight_or_nine_found == true:
			if SessionManager.current_save.language_selected == "English":
				input_num_error.text = "Invalid Input!\nOctal numbers can't contain 8 or 9!"
			elif SessionManager.current_save.language_selected == "Deutsch":
				input_num_error.text = "Ungültige Eingabe!\nOktalzahlen können keine 8 oder 9 haben!"
			input_num_error.visible = true
		else:
			input_num_error.visible = false


func create_syllable_buttons() -> void:
	for i: int in octal_syllables.size():
		var syllable_button: Node = syllable_scene.instantiate()
		hbox_emphasis.add_child(syllable_button)
		syllable_button.index = i
		syllable_button.text = octal_syllables[i].to_lower()


func remove_all_syllable_buttons() -> void:
	for i: Node in hbox_emphasis.get_children():
		i.queue_free()


func check_emphasis() -> bool:
	var result: bool = false
	var syllable_buttons: Array[Node] = hbox_emphasis.get_children()
	var emphasis_count: int = 0
	
	for i: int in hbox_emphasis.get_children().size():
		if syllable_buttons[i].text == syllable_buttons[i].text.to_upper():
			if emphasis_count > 0:
				result = false
				break
			else:
				if syllable_buttons[i].index == emphasis_at:
					result = true
				else:
					result = false
					break
				
				emphasis_count += 1
	
	return result


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Enter"):
		_on_confirm_pressed()


func _signal_play_again_pressed_emitted() -> void:
	get_tree().reload_current_scene()
