extends Control

@export var game_scene: PackedScene
@export var auth_scene: PackedScene
@export var leaderboard_scene: PackedScene

func _ready():
	$PanelContainer/MarginContainer/VBoxContainer/PlayButton.text = "Start game"
	$PanelContainer/MarginContainer/VBoxContainer/LeaderboardButton.text = "Leaderboard"
	$PanelContainer/MarginContainer/VBoxContainer/AuthButton.text = "Login"
	$PanelContainer/MarginContainer/VBoxContainer/QuitButton.text = "Quit"

	$PanelContainer/MarginContainer/VBoxContainer/PlayButton.pressed.connect(_on_play_pressed)
	$PanelContainer/MarginContainer/VBoxContainer/LeaderboardButton.pressed.connect(_on_leaderboard_pressed)
	$PanelContainer/MarginContainer/VBoxContainer/AuthButton.pressed.connect(_on_auth_pressed)
	$PanelContainer/MarginContainer/VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _on_play_pressed():
	if game_scene:
		get_tree().change_scene_to_packed(game_scene)

func _on_leaderboard_pressed():
	if leaderboard_scene:
		get_tree().change_scene_to_packed(leaderboard_scene)

func _on_auth_pressed():
	if auth_scene:
		get_tree().change_scene_to_packed(auth_scene)

func _on_quit_pressed():
	get_tree().quit()
