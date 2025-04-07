extends CharacterBody2D

@export var animated_sprite: AnimatedSprite2D
@export var portal_sprite: AnimatedSprite2D
@export var hp_bar: TextureProgressBar
@export var stamina_bar: TextureProgressBar
@export var bullet_scene: PackedScene

@export var speed: float = 100.0
@export var run_multiplier: float = 2.5
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
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	stamina_bar.max_value = max_stamina
	stamina_bar.value = stamina
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _physics_process(delta: float):
	if is_rolling:
		roll_timer -= delta
		velocity = velocity.move_toward(Vector2.ZERO, roll_friction * delta)
		if roll_timer <= 0:
			is_rolling = false
		move_and_slide()
		return

	var input_vector = Vector2.ZERO
	input_vector.y -= int(Input.is_action_pressed("move_up"))
	input_vector.y += int(Input.is_action_pressed("move_down"))
	input_vector.x -= int(Input.is_action_pressed("move_left"))
	input_vector.x += int(Input.is_action_pressed("move_right"))

	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		direction = input_vector

	if is_sliding:
		velocity = velocity.move_toward(Vector2.ZERO, slide_friction * delta)
		if Input.is_action_just_pressed("roll") and stamina >= 20:
			start_roll(boosted_roll_speed)
			is_sliding = false
		elif not Input.is_action_pressed("slide") or velocity.length() < 50:
			is_sliding = false

	elif Input.is_action_just_pressed("slide"):
		is_sliding = true
		velocity = direction * slide_speed
		animated_sprite.play("slide_" + get_direction_name(direction))

	elif Input.is_action_just_pressed("roll") and stamina >= 20:
		start_roll(roll_speed)

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

	if not is_sliding and not is_rolling:
		stamina = min(stamina + stamina_regen_rate * delta, max_stamina)

	hp_bar.value = hp
	stamina_bar.value = stamina

	move_and_slide()

func start_roll(speed_value: float):
	is_rolling = true
	roll_timer = roll_duration
	velocity = direction * speed_value
	animated_sprite.play("roll_" + get_direction_name(direction))
	stamina -= 20

func _process(_delta: float):
	# Portál mozgatása az egér irányába
	var mouse_pos = get_global_mouse_position()
	var portal_offset = (mouse_pos - global_position).normalized() * 24
	$Portal.position = portal_offset

	# Portál animáció az irány alapján
	var angle = portal_offset.angle()
	var abs_angle = abs(rad_to_deg(angle))
	if (abs_angle < 30 or abs_angle > 150):
		portal_sprite.play("horizontal")
	elif (abs_angle >= 60 and abs_angle <= 120):
		portal_sprite.play("vertical")
	else:
		portal_sprite.play("diagonal")

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		fire_bullet()

func fire_bullet():
	if not bullet_scene:
		push_error("Bullet scene nincs hozzárendelve!")
		return

	var bullet_instance = bullet_scene.instantiate()
	var portal_local_pos = $Portal.position
	var mouse_pos = get_global_mouse_position()
	var direction_vector = (mouse_pos - global_position - portal_local_pos).normalized()

	bullet_instance.position = portal_local_pos
	bullet_instance.direction = direction_vector
	bullet_instance.rotation = direction_vector.angle()

	get_node("Bullets").add_child(bullet_instance)

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
