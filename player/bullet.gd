extends Node2D

@export var speed: float = 400.0
@export var direction: Vector2 = Vector2.ZERO

var lifetime: float = 5.0
var time_alive: float = 0.0

func _ready():
	if direction != Vector2.ZERO:
		rotation = direction.angle()
	else:
		direction = Vector2.RIGHT

func _process(delta: float):
	position += direction * speed * delta
	time_alive += delta
	if time_alive >= lifetime:
		queue_free()
