extends Node2D


const MAX_LEN_SIZE: int = 13


@onready var num_func: Node2D = $Number
@onready var input_field: Control = $"Input Field/Input"
@onready var num_result: Control = $"Num Result Field/PanelContainer/Num Result"
@onready var octal_as_text: Control = $"Text Result Field/PanelContainer/Octal Number as Text"
@onready var emphasis_result: Control = $"CenterContainer/PanelContainer/Emphasis Result"
@onready var version: Control = $Version
@onready var keyboard_keys: Control = $"Keyboard Keys"

var input_field_text_without_decimal_points: String = ""
var keyboard_keys_on: bool = true


func _ready() -> void:
	version.text = Global.version_text


func _update_input_field(input: String) -> void:
	input_field_text_without_decimal_points += input
	input_field.text = num_func.add_decimal_points(input_field_text_without_decimal_points)
func _add_num_if_len_is_not_max(input: String) -> void:
	if num_func.is_octal(input_field_text_without_decimal_points) == false:
		if input_field_text_without_decimal_points.length() < MAX_LEN_SIZE - 1:
			_update_input_field(input)
	else:
		if input_field_text_without_decimal_points.length() < MAX_LEN_SIZE:
			_update_input_field(input)
func _is_eight_or_nine_in_str(num_as_str: String) -> bool:
	var result: bool = false
	
	for i: String in num_as_str:
		if i == "8" or i == "9":
			result = true
			break
	
	return result
func _other_keyboard_inputs(event: InputEvent) -> void:
	if event.is_action_pressed("backspace"):
		input_field_text_without_decimal_points = input_field_text_without_decimal_points.left(-1)
		input_field.text = num_func.add_decimal_points(input_field_text_without_decimal_points)
	elif event.is_action_pressed("enter"):
		if input_field_text_without_decimal_points.length() > 0:
			if num_func.is_octal(input_field_text_without_decimal_points) == true:
				num_result.text = input_field.text + " -> " + num_func.add_decimal_points(num_func.octal2deci(input_field_text_without_decimal_points))
				octal_as_text.text = num_func.octal_num_in_text(input_field_text_without_decimal_points)
				
				if octal_as_text.text != "Es gibt noch keine Namen für Oktalzahlen\nin Na'vi, die höher sind als die 077.777!":
					emphasis_result.text = num_func.display_syllables(num_func.find_emphasis(octal_as_text.text))
				else:
					emphasis_result.text = "-"
			else:
				num_result.text = input_field.text + " -> " + num_func.add_decimal_points(num_func.deci2octal(input_field_text_without_decimal_points))
				octal_as_text.text = num_func.octal_num_in_text(num_func.deci2octal(input_field_text_without_decimal_points))
				
				if octal_as_text.text != "Es gibt noch keine Namen für Oktalzahlen\nin Na'vi, die höher sind als die 077.777!":
					emphasis_result.text = num_func.display_syllables(num_func.find_emphasis(octal_as_text.text))
				else:
					emphasis_result.text = "-"
			input_field_text_without_decimal_points = ""
			input_field.text = ""
			num_result.visible = true
			octal_as_text.visible = true
			emphasis_result.visible = true
	elif event.is_action_pressed("octal"):
		if input_field_text_without_decimal_points.length() > 0:
			if num_func.is_octal(input_field_text_without_decimal_points) == true:
				input_field_text_without_decimal_points = num_func.deci(input_field_text_without_decimal_points)
				input_field.text = num_func.add_decimal_points(input_field_text_without_decimal_points)
			else:
				if _is_eight_or_nine_in_str(input_field_text_without_decimal_points) == false and input_field_text_without_decimal_points.length() < MAX_LEN_SIZE:
					input_field_text_without_decimal_points = num_func.octal(input_field_text_without_decimal_points)
					input_field.text = num_func.add_decimal_points(input_field_text_without_decimal_points)
				else:
					pass
func _num_inputs(event: InputEvent) -> void:
	if event.is_action_pressed("zero"):
		_add_num_if_len_is_not_max("0")
	elif event.is_action_pressed("one"):
		_add_num_if_len_is_not_max("1")
	elif event.is_action_pressed("two"):
		_add_num_if_len_is_not_max("2")
	elif event.is_action_pressed("three"):
		_add_num_if_len_is_not_max("3")
	elif event.is_action_pressed("four"):
		_add_num_if_len_is_not_max("4")
	elif event.is_action_pressed("five"):
		_add_num_if_len_is_not_max("5")
	elif event.is_action_pressed("six"):
		_add_num_if_len_is_not_max("6")
	elif event.is_action_pressed("seven"):
		_add_num_if_len_is_not_max("7")
	elif event.is_action_pressed("eight"):
		if input_field_text_without_decimal_points.length() == 1:
			if input_field.text[0] != "0":
				_add_num_if_len_is_not_max("8")
		elif num_func.is_octal(input_field_text_without_decimal_points) == false: 
			_add_num_if_len_is_not_max("8")
	elif event.is_action_pressed("nine"):
		if input_field_text_without_decimal_points.length() == 1:
			if input_field.text[0] != "0":
				_add_num_if_len_is_not_max("9")
		elif num_func.is_octal(input_field_text_without_decimal_points) == false: 
			_add_num_if_len_is_not_max("9")

func _input(event: InputEvent) -> void:
	if keyboard_keys_on == false:
		if input_field.text == "00":
			_other_keyboard_inputs(event)
		else:
			_num_inputs(event)
			_other_keyboard_inputs(event)


func _on_confirm_button_pressed():
	keyboard_keys_on = false
	keyboard_keys.visible = false
	
