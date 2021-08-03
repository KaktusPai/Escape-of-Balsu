extends Node2D

var direction = Vector2.LEFT
var speed = 1000
var player = null

func _process(delta):
	 translate(direction * speed * delta)

func _on_BulletArea_body_entered(body: Node):
	if body is TileMap:
		queue_free()
