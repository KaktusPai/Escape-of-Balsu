var awoke = false

func enter(host, _arguments):
	print("boss_asleep")
	host.aniNode.position.y += 1200
	execute(host)

func execute(host, _delta = 0.016666):
	if host.player != null && awoke == false:
		host.animation.play("Awaken")
		host.nextStateTimer.start()
		awoke = true
	if host.nextStateTimer.is_stopped() && awoke == true:
		return {
		"state": host.States["SHOOTMOVE"]
		}

func exit(_host):
	pass
