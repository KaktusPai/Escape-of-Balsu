extends Node2D

# Bullet shooting
const bulletPath = preload("res://src/Bullet/Bullet.tscn")
onready var aniNode = $AniNode
onready var shootTimer = $AniNode/ShootTimer
onready var shootRange = $AniNode/ShootRange
export var shootDelay = 1.8
export var shootRangeModifier = 1.0
var player = null

# Health
export (float) var maxHealth = 60
onready var health = maxHealth setget _set_health

# HP Bar
onready var healthUnder = $AniNode/HealthBar/HealthUnder
onready var healthOver = $AniNode/HealthBar/HealthOver
onready var updateTween = $AniNode/HealthBar/UpdateTween

func _ready():
	shootTimer.wait_time = shootDelay
	shootRange.scale = shootRange.scale * shootRangeModifier

# PLAYER HEALTH
func _on_health_updated(health):
	healthOver.value = health
	updateTween.interpolate_property(healthUnder, "value", healthUnder.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.4)
	updateTween.start()

func damage(amount):
	_set_health(health - amount)

func kill():
	queue_free()

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, maxHealth)
	if health != prev_health:
		_on_health_updated(health)
		if health == 0:
			kill()

# SHOOTING AT PLAYER
func _process(_delta):
	if shootTimer.is_stopped():
		if player != null:
			shootTimer.start()
			shoot()

func shoot():
	var bullet = bulletPath.instance()
	get_parent().add_child(bullet)
	bullet.position = aniNode.global_position
	var dir = (player.global_position - aniNode.global_position).normalized()
	bullet.global_rotation = dir.angle() + PI / 2.0
	bullet.direction = dir

func _on_ShootRange_body_entered(body):
	if body != self and body.is_in_group("actors"):
		player = body
		print("player in range")

func _on_ShootRange_body_exited(body):
	if body != self and body.is_in_group("actors"):
		player = null
		print("player out of range")

func _on_NormalEnemyArea_body_entered(body):
	if body != self and body.is_in_group("hook"):
		damage(20)
		body.get_parent()._release()
