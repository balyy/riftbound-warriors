extends Control


func _ready():
	Supabase.auth.connect("error", Callable(self, "_on_auth_error"))


func insert():
	Supabase.database.connect("inserted", Callable(self, "_on_inserted"))
	var query = SupabaseQuery.new().from("profiles").insert([
		"",
		$"%SignUpUsernameLineEdit".text,
		$"%SignUpEmailLineEdit".text,
		"HUN",
		"3"
	], true)
	Supabase.database.query(query)


func _on_inserted(result : Array):
	print(result)


var failed = 0
func _on_auth_error(error: Object):
	print("Authentication error: ", error)
	%LogInStateLabel.text = error.to_string()
	$"%SignUpStateLabel".text = error.to_string()
	
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


func _on_signed_in(user : SupabaseUser):
	print("Successfully signed as ", user)
	get_tree().change_scene_to_file("res://main.tscn")


func sign_up():
	if not Supabase.auth.is_connected("signed_in", Callable(self, "on_signed_in")):
		Supabase.auth.connect("signed_up", Callable(self, "on_signed_up"))
	Supabase.auth.sign_up(
		%SignUpEmailLineEdit.text,
		%SignUpPasswordLineEdit.text
		)


func on_signed_up(user : SupabaseUser):
	print("Succesfully signed up as ", user)
	#insert()


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
