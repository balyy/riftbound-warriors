extends Node2D

@export var speed: float = 400.0  # A lövedék sebessége
@export var direction: Vector2 = Vector2.ZERO  # A lövedék iránya

var lifetime: float = 5.0  # A lövedék élettartama
var time_alive: float = 0.0  # A lövedék életének ideje

# A lövedék mozgása
func _ready():
	# Kezdeti irány beállítása
	if direction != Vector2.ZERO:
		rotation = direction.angle()  # Beállítjuk a lövedék irányát
	else:
		# Alapértelmezett irány (pl. felfelé)
		direction = Vector2.UP

func _process(delta: float):
	# A lövedék mozgása
	position += direction * speed * delta
	
	# Élettartam csökkentése
	time_alive += delta
	
	# Ha a lövedék élettartama lejár, eltávolítjuk
	if time_alive >= lifetime:
		queue_free()
