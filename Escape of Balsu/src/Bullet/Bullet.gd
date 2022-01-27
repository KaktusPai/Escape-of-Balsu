extends Node2D

var direction = Vector2.LEFT
var speed = 1000
var isPattern = false

func _ready():
	pass

func _process(delta):
	if !isPattern:
		translate(direction * speed * delta)
	else:
		position += transform.x * speed * delta

func _on_BulletArea_body_entered(body: Node):
	if body is TileMap:
		queue_free()
