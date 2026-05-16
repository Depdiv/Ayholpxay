extends Node


var current_save: UserSaveData

func _ready() -> void:
	current_save = SaveManager.load_game()
