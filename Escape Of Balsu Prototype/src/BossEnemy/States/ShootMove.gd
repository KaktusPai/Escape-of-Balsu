func enter(host, _arguments):
	print("shoot_move")
	host.nextStateTimer.start()
	host.nextStateTimer.wait_time = 12
	host.animation.play("MoveAround")
	host.shootTimer.wait_time = host.normalShootDelay
	execute(host)

func execute(host, _delta = 0.016666):
	if host.shootTimer.is_stopped():
		if host.player !=null:
			host.shootTimer.start()
			host.shoot()

	if host.nextStateTimer.is_stopped():
		return {
		"state": host.States["SHOOTPATTERN"]
		}
func exit(_host):
	pass
