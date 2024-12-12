extends Control

func _ready():
	Supabase.auth.connect("error", Callable(self, "_on_auth_error"))
	
	signup("viraghbalazs2005@gmail.com", "test123")
	
func signup(email, password):	#	FOR DEBUGGING !! DO NOT USE
	print("Attempting to sign up: ", email)
	var response = Supabase.auth.sign_up(email, password)
	print("Signup response: ", response)


func update_profile(user_id: String):
	Supabase.database.connect("updated", Callable(self, "_on_updated"))
	var query = SupabaseQuery.new().from("profiles").update({
		username = %SignUpUsernameLineEdit.text,
		email = %SignUpEmailLineEdit.text,
		country_id = "HUN",
		role_id = 3
	}).eq("id", user_id)
	Supabase.database.query(query)


func _on_updated(result: Array):
	print("Profile updated successfully: ", result)


var failed = 0
func _on_auth_error(error: Object):
	print("Authentication error: ", error)
	%LogInStateLabel.text = error.to_string()
	%SignUpStateLabel.text = error.to_string()

	%LogInEmailLineEdit.text = ""
	%LogInPasswordLineEdit.text = ""

	%SignUpEmailLineEdit.text = ""
	%SignUpPasswordLineEdit.text = ""
	%SignUpUsernameLineEdit.text = ""

	failed += 1
	if failed >= 3:
		%FailedTimeout.start()
		%LogInButton.disabled = true
		%SignUpButton.disabled = true
		%LogInStateLabel.text = "Failed too many times, please wait"
		$"%SignUpStateLabel".text = "Failed too many times, please wait"
		failed = 0


func sign_in():
	if not Supabase.auth.is_connected("signed_in", Callable(self, "_on_signed_in")):
		Supabase.auth.connect("signed_in", Callable(self, "_on_signed_in"))
	Supabase.auth.sign_in(
		%LogInEmailLineEdit.text,
		%LogInPasswordLineEdit.text
	)


func _on_signed_in(user: SupabaseUser):
	print("Successfully signed in as ", user)
	get_tree().change_scene_to_file("res://main.tscn")


func sign_up():
	if not Supabase.auth.is_connected("signed_in", Callable(self, "on_signed_in")):
		Supabase.auth.connect("signed_up", Callable(self, "on_signed_up"))
	Supabase.auth.sign_up(
		%SignUpEmailLineEdit.text,
		%SignUpPasswordLineEdit.text
	)


func on_signed_up(user: SupabaseUser):
	print("Successfully signed up as ", user)
	Supabase.auth.sign_in(
		%SignUpEmailLineEdit.text,
		%SignUpPasswordLineEdit.text
	)
	update_profile(user.id) # Frissítjük a felhasználó profilját


func _on_login_button_pressed() -> void:
	print("login")
	sign_in()


func _on_sign_up_button_pressed() -> void:
	print("register")
	sign_up()


func _on_failed_timeout_timeout() -> void:
	%LogInButton.disabled = false
	%SignUpButton.disabled = false


func _on_to_sign_up_button_pressed() -> void:
	%LogInPanel.visible = false
	%SignUpPanel.visible = true


func _on_to_log_in_button_pressed() -> void:
	%LogInPanel.visible = true
	%SignUpPanel.visible = false
