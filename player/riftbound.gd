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
var stamina: float = 100.0
var stamina_regen_rate: float = 10.0
var stamina_drain_rate: float = 20.0
var stamina_depleted: bool = false

var is_sliding: bool = false
var is_rolling: bool = false
var roll_timer: float = 0.0
var direction: Vector2 = Vector2.DOWN
var roll_velocity: Vector2 = Vector2.ZERO

func _ready():
	if not animated_sprite:
		push_error("AnimatedSprite2D is not assigned!")
	if not hp_bar or not stamina_bar:
		push_error("HP Bar vagy Stamina Bar nincs hozzárendelve!")

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
		if Input.is_action_just_pressed("roll") and stamina >= 20:
			is_rolling = true
			roll_timer = roll_duration
			velocity = direction * boosted_roll_speed
			animated_sprite.play("roll_" + get_direction_name(direction))
			stamina -= 20
			is_sliding = false  # Megszakítja a slide-ot
		elif not Input.is_action_pressed("slide") or velocity.length() < 50:
			is_sliding = false
	elif Input.is_action_just_pressed("slide"):
		is_sliding = true
		velocity = direction * slide_speed
		animated_sprite.play("slide_" + get_direction_name(direction))

	elif Input.is_action_just_pressed("roll") and stamina >= 20:
		is_rolling = true
		roll_timer = roll_duration
		velocity = direction * roll_speed
		animated_sprite.play("roll_" + get_direction_name(direction))
		stamina -= 20

	elif Input.is_action_pressed("run") and stamina > 0 and not stamina_depleted:
		velocity = direction * speed * run_multiplier
		animated_sprite.play("run_" + get_direction_name(direction))
		stamina -= stamina_drain_rate * delta
		if stamina <= 0:
			stamina = 0
			stamina_depleted = true
			await get_tree().create_timer(2.0).timeout
			stamina_depleted = false

	elif input_vector != Vector2.ZERO:
		velocity = direction * speed
		animated_sprite.play("walk_" + get_direction_name(direction))

	else:
		velocity = Vector2.ZERO
		animated_sprite.play("idle_" + get_direction_name(direction))

	# Stamina regenerálás
	if not is_sliding and not is_rolling:
		stamina = min(stamina + stamina_regen_rate * delta, max_stamina)

	hp_bar.value = hp
	stamina_bar.value = stamina

	move_and_slide()

func get_direction_name(dir: Vector2) -> String:
	if dir == Vector2.ZERO:
		return "down"
	elif dir.y < 0:
		return "upRight" if dir.x > 0 else "upLeft" if dir.x < 0 else "up"
	elif dir.y > 0:
		return "downRight" if dir.x > 0 else "downLeft" if dir.x < 0 else "down"
	elif dir.x > 0:
		return "right"
	elif dir.x < 0:
		return "left"
	return "down"
