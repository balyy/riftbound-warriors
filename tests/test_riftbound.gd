extends "res://addons/gut/test.gd"

var player

func before_each():
	player = preload("res://player/riftbound.tscn").new()
	player.base_character_stats = preload("res://player/CharacterStats.tres")
	player.base_weapon_stats = preload("res://player/WeaponStats.tres")
	player._ready()

func test_hp_initialized_correctly():
	assert_eq(player.hp, player.base_character_stats.max_hp)

func test_roll_consumes_stamina():
	var stamina_before = player.stamina
	player.start_roll(player.roll_speed)
	assert_lt(player.stamina, stamina_before, "Stamina should decrease after rolling")

func test_roll_should_decrease_stamina_and_set_velocity():
	var player = preload("res://player/riftbound.tscn").instantiate()
	add_child(player)

	player.stamina = 100
	player.direction = Vector2.RIGHT
	player.start_roll(300)

	assert_true(player.is_rolling)
	assert_gt(300, player.stamina) # stamina csökken
	assert_eq(player.velocity, Vector2.RIGHT * 300)

func test_take_damage_should_reduce_hp_and_kill_when_zero():
	var player = preload("res://player/riftbound.tscn").instantiate()
	add_child(player)

	player.hp = 10
	player.take_damage(10)
	assert_true(player.is_queued_for_deletion())
