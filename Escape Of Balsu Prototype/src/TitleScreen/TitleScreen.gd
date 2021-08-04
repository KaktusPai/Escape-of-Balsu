extends Control

onready var mainLevel = "res://Levels/LevelMain.tscn"

func _ready():
	pass

func _on_Play_button_up():
	queue_free()

func _on_Quit_button_up():
	get_tree().quit()
