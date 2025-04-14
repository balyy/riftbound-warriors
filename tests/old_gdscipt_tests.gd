extends "res://addons/gut/test.gd"

var character

func before_each():
	character = preload("res://player/riftbound.tscn").instantiate()
	add_child(character)

func after_each():
	character.queue_free()

# 1. Futás staminával
func test_run_with_stamina():
	character.stamina = 50
	Input.action_press("run")
	character._physics_process(0.1)
	assert_true(character.velocity.length() > character.speed, "A karakternek gyorsabban kell mozognia")
	Input.action_release("run")

# 2. Futás stamina nélkül
func test_run_without_stamina():
	character.stamina = 0
	Input.action_press("run")
	character._physics_process(0.1)
	assert_true(character.velocity.length() == character.speed, "A karakter nem futhat, ha nincs stamina")
	Input.action_release("run")

# 3. Gurulás működik
func test_roll_with_stamina():
	character.stamina = 50
	Input.action_press("roll")
	character._physics_process(0.1)
	assert_true(character.is_rolling, "A karakternek gurulnia kellene")
	Input.action_release("roll")

# 4. Gurulás stamina nélkül
func test_roll_without_stamina():
	character.stamina = 0
	Input.action_press("roll")
	character._physics_process(0.1)
	assert_false(character.is_rolling, "A karakter nem gurulhat, ha nincs stamina")
	Input.action_release("roll")

# 5. Csúszás
func test_slide_with_stamina():
	character.stamina = 50
	Input.action_press("slide")
	character._physics_process(0.1)
	assert_true(character.is_sliding, "A karakternek csúsznia kellene")
	Input.action_release("slide")

# 6. Sebzés
func test_take_damage():
	character.hp = 100
	character.take_damage(20)
	assert_eq(character.hp, 80, "A HP-nak 80-ra kellene csökkennie")

# 7. Gyógyulás
func test_heal():
	character.hp = 50
	character.gain_health(30)
	assert_eq(character.hp, 80, "A HP-nak 80-nak kellene lennie")

# 8. Halál
func test_death():
	character.hp = 10
	character.take_damage(20)
	assert_eq(character.hp, 0, "A HP-nak 0-nak kellene lennie")
	assert_false(character.is_alive(), "A karakternek halottnak kellene lennie")

# --- Lövedék tesztek ---
var bullet

func setup_bullet():
	bullet = preload("res://player/bullet.tscn").instantiate()
	bullet.direction = Vector2.RIGHT
	bullet.speed = 400
	add_child(bullet)

func cleanup_bullet():
	bullet.queue_free()

func test_bullet_movement():
	setup_bullet()
	var start_position = bullet.position
	bullet._process(0.1)
	assert_true(bullet.position.x > start_position.x, "A lövedéknek jobbra kellene mozognia")
	cleanup_bullet()

func test_bullet_lifetime():
	setup_bullet()
	bullet.time_alive = bullet.lifetime - 0.1
	bullet._process(0.1)
	assert_false(is_instance_valid(bullet), "A lövedéknek törlődnie kellene")
	# cleanup nem kell, már törölve

# --- Animációk ---
func test_idle_animation():
	character._physics_process(0.1)
	assert_eq(character.animated_sprite.animation, "idle_down", "Az idle animációnak kellene játszódnia")

func test_walk_animation():
	Input.action_press("move_up")
	character._physics_process(0.1)
	assert_eq(character.animated_sprite.animation, "walk_up", "A walk_up animációnak kellene játszódnia")
	Input.action_release("move_up")

func test_roll_animation():
	character.stamina = 50
	Input.action_press("roll")
	character._physics_process(0.1)
	assert_true("roll" in character.animated_sprite.animation, "A roll animációnak kellene játszódnia")
	Input.action_release("roll")
