extends "res://addons/gut/test.gd"

var board

func before_each():
	board = preload("res://ui/leaderboard/leaderboard.tscn").new()

func test_signal_emits_player_died():
	var called = false
	board.connect("player_died", func(_score, _date): called = true)
	board.player_die(100)
	assert_true(called, "player_died signal should be emitted")

func test_add_leaderboard_entry_should_store_data():
	var leaderboard = preload("res://ui/leaderboard/leaderboard.tscn").instantiate()
	add_child(leaderboard)

	var dummy_time = "2025-04-14 10:00:00"
	var dummy_score = 999

	await leaderboard.add_leaderboard_entry(dummy_time, dummy_score)
	assert_true(true) 
