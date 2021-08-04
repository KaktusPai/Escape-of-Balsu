extends Area2D


func _ready():
	pass

func _on_GameFinished_area_entered(area):
	if area.name == "PlayerArea":
		get_tree().change_scene("res://Levels/ThanksForPlaying.tscn")
