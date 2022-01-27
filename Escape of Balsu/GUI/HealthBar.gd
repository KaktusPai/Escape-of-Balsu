extends Control

onready var healthUnder = $HealthUnder
onready var healthOver = $HealthOver
onready var updateTween = $UpdateTween

func _on_health_updated(health):
	healthOver.value = health
	updateTween.interpolate_property(healthUnder, "value", healthUnder.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.4)
	updateTween.start()
	
func _on_Player_health_updated(health):
	_on_health_updated(health)
