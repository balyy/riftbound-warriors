extends Control

func _ready():
	pass


func _on_sign_up_button_pressed() -> void:
	var email = %EmailLineEdit.text
	var password = %PasswordLineEdit.text
	Supabase.auth.sign_up(email, password)
	


func _on_login_button_pressed() -> void:
	var email = %EmailLineEdit.text
	var password = %PasswordLineEdit.text
	Supabase.auth.sign_in(email, password)
	if Supabase.auth.sign_in(email, password).completed:
		get_tree().change_scene_to_file("res://main.tscn")


func on_error():
	pass


func on_login_succeded(auth):
	pass


func on_login_failed(auth):
	pass


func on_signup_succeded(auth):
	pass


func on_signup_failed(auth):
	pass
