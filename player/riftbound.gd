extends CharacterBody2D

@export var animated_sprite: AnimatedSprite2D
@export var portal_sprite: AnimatedSprite2D
@export var hp_bar: TextureProgressBar
@export var stamina_bar: TextureProgressBar

@export var speed: float = 100.0
@export var run_multiplier: float = 1.5
@export var roll_speed: float = 300.0
@export var boosted_roll_speed: float = 400.0
@export var slide_speed: float = 250.0
@export var roll_duration: float = 0.5
@export var slide_friction: float = 200.0
@export var roll_friction: float = 500.0

var max_hp: int = 100
var hp: int = 100
var max_stamina: int = 100
var stamina: int = 100
var stamina_regen_rate: float = 10.0  # Másodpercenként ennyit regenerál
var stamina_drain_rate: float = 2.0  # Futás közben fél mp alatt ennyi fogy

var is_sliding: bool = false
var is_rolling: bool = false
var roll_timer: float = 0.0
var direction: Vector2 = Vector2.DOWN
var roll_velocity: Vector2 = Vector2.ZERO

func _ready():
	if not animated_sprite:
		push_error("AnimatedSprite2D is not assigned!")
	
	# UI elemek inicializálása
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	stamina_bar.max_value = max_stamina
	stamina_bar.value = stamina

func _physics_process(delta: float):
	if is_rolling:
		roll_timer -= delta
		velocity = velocity.move_toward(Vector2.ZERO, roll_friction * delta)
		if roll_timer <= 0:
			is_rolling = false
		move_and_slide()
		return

	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1

	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		direction = input_vector

	if is_sliding:
		velocity = velocity.move_toward(Vector2.ZERO, slide_friction * delta)
		if not Input.is_action_pressed("slide") or velocity.length() < 50:
			is_sliding = false
	elif Input.is_action_just_pressed("slide"):
		is_sliding = true
		velocity = direction * slide_speed
		animated_sprite.play("slide_" + get_direction_name(direction))

	# Ha slide közben próbálunk roll-olni
	elif Input.is_action_just_pressed("roll") and stamina >= 20:
		if not is_rolling:  # Csak akkor roll-olhat, ha nem rolling
			# Ha csúszás közben vagyunk, akkor boostolt roll
			if is_sliding:
				velocity = direction * boosted_roll_speed
			else:
				velocity = direction * roll_speed
			is_rolling = true
			roll_timer = roll_duration
			animated_sprite.play("roll_" + get_direction_name(direction))
			stamina -= 20  # Roll 20 staminát fogyaszt

	# Futás
	elif Input.is_action_pressed("run") and stamina > 0:
		velocity = direction * speed * run_multiplier
		animated_sprite.play("run_" + get_direction_name(direction))
		stamina -= stamina_drain_rate * delta  # Futás közben fogy a stamina
	elif Input.is_action_pressed("run") and stamina <= 0:
		velocity = direction * speed  # Ha nincs stamina, akkor csak séta
		animated_sprite.play("walk_" + get_direction_name(direction))

	elif input_vector != Vector2.ZERO:
		velocity = direction * speed
		animated_sprite.play("walk_" + get_direction_name(direction))

	else:
		velocity = Vector2.ZERO
		animated_sprite.play("idle_" + get_direction_name(direction))

	# Stamina regenerálódás (ha nem csúszik vagy roll-ol)
	if not is_sliding and not is_rolling:
		stamina = min(stamina + stamina_regen_rate * delta, max_stamina)

	# Frissítjük a UI-t
	hp_bar.value = hp
	stamina_bar.value = stamina

	move_and_slide()

func get_direction_name(dir: Vector2) -> String:
	if dir == Vector2.ZERO:
		return "down"
	elif dir.y < 0:
		if dir.x > 0:
			return "upRight"
		elif dir.x < 0:
			return "upLeft"
		else:
			return "up"
	elif dir.y > 0:
		if dir.x > 0:
			return "downRight"
		elif dir.x < 0:
			return "downLeft"
		else:
			return "down"
	elif dir.x > 0:
		return "right"
	elif dir.x < 0:
		return "left"
	return "down"
