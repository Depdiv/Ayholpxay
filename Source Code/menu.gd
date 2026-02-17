extends Control


var number_calculator: PackedScene = preload("res://number_converter.tscn")

@onready var version: Control = $Control/Version


func _ready():
	version.text = Global.version_text


func _on_quit_pressed():
	get_tree().quit()


func _on_start_pressed():
	get_tree().change_scene_to_file("res://number_converter.tscn")
