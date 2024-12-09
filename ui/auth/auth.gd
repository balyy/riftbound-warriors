extends Control


func _ready():
	Supabase.auth.connect("error", Callable(self, "_on_auth_error"))

var failed = 0
func _on_auth_error(error: Object):
	print("Authentication error: ", error)
	%StateLabel.text = error.to_string()
	%EmailLineEdit.text = ""
	%PasswordLineEdit.text = ""
	
	failed += 1
	if failed >= 3:
		%FailedTimeout.start()
		%LoginButton.disabled = true
		%SignUpButton.disabled = true
		%StateLabel.text = "Failed too many times, please wait"
		failed = 0


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


func _on_failed_timeout_timeout() -> void:
	%LoginButton.disabled = false
	%SignUpButton.disabled = false
