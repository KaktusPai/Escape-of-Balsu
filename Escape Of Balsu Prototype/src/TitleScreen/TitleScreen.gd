extends Control

onready var mainLevel = "res://Levels/LevelMain.tscn"

func _ready():
	pass

func _on_Play_button_up():
	queue_free()
