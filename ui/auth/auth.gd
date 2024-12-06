extends Control

func _ready():
	Supabase.auth.connect("error", Callable(self, "_on_auth_error"))


func _on_auth_error(error: Object):
	print("Authentication error: ", error)
	%StateLabel.text = error.to_string()



func sign_in():
	if not Supabase.auth.is_connected("signed_in", Callable(self, "_on_signed_in")):
		Supabase.auth.connect("signed_in", Callable(self, "_on_signed_in"))
	Supabase.auth.sign_in(%EmailLineEdit.text, %PasswordLineEdit.text)

func _on_signed_in(user : SupabaseUser):
	print("Successfully signed as ", user)
	get_tree().change_scene_to_file("res://main.tscn")

func sign_up():
	if not Supabase.auth.is_connected("signed_in", Callable(self, "on_signed_in")):
		Supabase.auth.connect("signed_up", Callable(self, "on_signed_up"))
	Supabase.auth.sign_up(%EmailLineEdit.text, %PasswordLineEdit.text)

func on_signed_up(user : SupabaseUser):
	print("Succesfully signed up as ", user)


func _on_login_button_pressed() -> void:
	print("login")
	sign_in()


func _on_sign_up_button_pressed() -> void:
	print("register")
	sign_up()
