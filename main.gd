extends Control

@export var game_scene: PackedScene
@export var auth_scene: PackedScene

func _ready():
	$PlayButton.text = "Játék indítása"
	$AuthButton.text = "Bejelentkezés"
	$QuitButton.text = "Kilépés"

	$PlayButton.pressed.connect(_on_play_pressed)
	$AuthButton.pressed.connect(_on_auth_pressed)
	$QuitButton.pressed.connect(_on_quit_pressed)

func _on_play_pressed():
	if game_scene:
		get_tree().change_scene_to_packed(game_scene)

func _on_auth_pressed():
	if auth_scene:
		get_tree().change_scene_to_packed(auth_scene)

func _on_quit_pressed():
	get_tree().quit()
