extends "res://addons/gut/test.gd"

var game

func before_each():
	game = preload("res://scripts/game.gd").new()

func test_initial_score_is_zero():
	assert_eq(game.score, 0, "Score should be initialized to 0")

func test_room_load_adds_to_loaded_rooms():
	game.loaded_rooms = []
	game.load_room()
	assert_gt(game.loaded_rooms.size(), 0, "Rooms should be added to loaded_rooms")


func test_should_load_new_room_when_called():
	var game = preload("res://game.tscn").instantiate()
	add_child(game)

	var initial_room_count = game.loaded_rooms.size()
	game.load_room()
	assert_true(game.loaded_rooms.size() > initial_room_count)

func test_should_load_endroom_after_five_rooms():
	var game = preload("res://game.tscn").instantiate()
	add_child(game)

	for i in range(5):
		game.load_room()

	assert_true(game.loaded_rooms[-1].scene_file_path.contains("endroom"))
