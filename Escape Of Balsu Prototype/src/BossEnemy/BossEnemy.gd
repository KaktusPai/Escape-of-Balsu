extends Node2D

# Bullet shooting
const bulletPath = preload("res://src/Bullet/Bullet.tscn")
onready var aniNode = $AniNode
onready var shootTimer = $AniNode/ShootTimer
onready var nextStateTimer = $AniNode/NextStateTimer
onready var shootRange = $AniNode/ShootRange
export var normalShootDelay = 0.25
export var patternShootDelay = 0.1
var player = null
#var rng = RandomNumberGenerator.new()

#Rotate shooting
const rotateSpeed = 100
const spawnPointCount = 6
export var rotateShootDelay = 0.35
const radius = 100
onready var rotater = $AniNode/Rotater

# States
const StateManagerReference = preload("res://Utils/StateManager.gd")
onready var States = {
	"ASLEEP": load("res://src/BossEnemy/States/Asleep.gd").new(),
	"SHOOTMOVE": load("res://src/BossEnemy/States/ShootMove.gd").new(),
	"SHOOTPATTERN": load("res://src/BossEnemy/States/ShootPattern.gd").new(),
}
onready var StateManager = StateManagerReference.new(self, States, "ASLEEP")

# Health
export (float) var maxHealth = 500
onready var health = maxHealth setget _set_health

# HP Bar
onready var healthUnder = $AniNode/HealthBar/HealthUnder
onready var healthOver = $AniNode/HealthBar/HealthOver
onready var updateTween = $AniNode/HealthBar/UpdateTween

# Other
onready var animation = $AniNode/AnimationPlayer
signal makeDoor()
signal removeDoor()

func _ready():
	shootTimer.wait_time = normalShootDelay

# PLAYER HEALTH
# warning-ignore:shadowed_variable
func _on_health_updated(health):
	healthOver.value = health
	updateTween.interpolate_property(healthUnder, "value", healthUnder.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.4)
	updateTween.start()

func damage(amount):
	_set_health(health - amount)

func kill():
	animation.stop()
	emit_signal("removeDoor")
	queue_free()

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, maxHealth)
	if health != prev_health:
		_on_health_updated(health)
		if health == 0:
			kill()

# SHOOTING AT PLAYER
func _physics_process(delta):
	StateManager._handle_state(delta)

func shoot():
	var bullet = bulletPath.instance()
	get_parent().add_child(bullet)
	bullet.position = aniNode.global_position
	var dir = (player.global_position - aniNode.global_position).normalized() 
	bullet.global_rotation = dir.angle() + (PI / 2.0) 
	bullet.direction = dir 

func _on_ShootRange_body_entered(body):
	if body != self and body.is_in_group("actors"):
		player = body
		emit_signal("makeDoor")
		print("Player in boss range")

func _on_ShootRange_body_exited(body):
	if body != self and body.is_in_group("actors"):
		player = null
		print("Player in boss range")

func _on_NormalEnemyArea_body_entered(body):
	if body != self and body.is_in_group("hook"):
		damage(10)
		body.get_parent()._release()
