extends TileMap

func _on_BossEnemy_makeDoor():
	set_cell(22,24,11)
	set_cell(22,25,11)

func _on_BossEnemy_removeDoor():
	print ("removing?")
	set_cell(52,7,-1)
	set_cell(53,7,-1)
	set_cell(54,7,-1)
	set_cell(55,7,-1)
