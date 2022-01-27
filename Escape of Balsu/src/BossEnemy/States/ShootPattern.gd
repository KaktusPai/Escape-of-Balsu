func enter(host, _arguments):
	print("shoot_pattern")
	host.aniNode.position = Vector2.ZERO
	host.animation.stop()
	host.shootTimer.wait_time = host.patternShootDelay
	
	var step = 2 * PI / host.spawnPointCount
	
	for i in range(host.spawnPointCount):
		var spawnPoint = Node2D.new()
		var pos = Vector2(host.radius, 0).rotated(step * i)
		spawnPoint.position = pos
		spawnPoint.rotation = pos.angle()
		host.rotater.add_child(spawnPoint)
	
	host.nextStateTimer.start()
	execute(host)

func execute(host, _delta = 0.016666):
	var newRotation = host.rotater.rotation_degrees + host.rotateSpeed * _delta
	host.rotater.rotation_degrees = fmod(newRotation, 360)
	
	if host.shootTimer.is_stopped():
		for s in host.rotater.get_children():
			var bullet = host.bulletPath.instance()
			host.get_tree().root.add_child(bullet)
			bullet.isPattern = true
			bullet.position = s.global_position
			bullet.rotation = s.global_rotation
		host.shootTimer.start()
	
	if host.nextStateTimer.is_stopped():
		return {
		"state": host.States["SHOOTMOVE"]
		}

func exit(_host):
	pass
