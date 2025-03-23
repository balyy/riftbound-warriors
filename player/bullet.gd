extends CharacterBody2D

@export var speed: float = 500.0  # Lövedék sebessége
@export var lifetime: float = 3.0  # Meddig marad meg a lövedék?

var direction: Vector2 = Vector2.ZERO

func _ready():
	# Elindítja az animációt
	$AnimatedSprite2D.play("default") 
	
	# Időzítő a lövedék eltüntetésére
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	if direction == Vector2.ZERO:
		return
	
	# Lövedék mozgatása
	velocity = direction * speed
	move_and_slide()

func set_direction(new_direction: Vector2):
	direction = new_direction.normalized()
	update_animation(direction)

func update_animation(dir: Vector2):
	var angle = rad_to_deg(atan2(dir.y, dir.x))

	if (-22.5 <= angle and angle < 22.5) or (157.5 <= angle or angle < -157.5):
		$AnimatedSprite2D.play("horizontal")  # Balra vagy jobbra
	elif (67.5 <= angle and angle < 112.5) or (-112.5 <= angle and angle < -67.5):
		$AnimatedSprite2D.play("vertical")  # Felfelé vagy lefelé
	else:
		$AnimatedSprite2D.play("diagonal")  # Átlós mozgás

func _on_body_entered(body):
	# Ha a lövedék beleütközik valamibe, eltűnik
	queue_free()
