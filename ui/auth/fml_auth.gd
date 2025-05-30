extends Control
class_name FMLAuth

func _ready():
	Supabase.auth.connect("error", Callable(self, "_on_auth_error"))
	Supabase.database.connect("updated", Callable(self, "_on_updated"))
	Supabase.auth.connect("signed_in", Callable(self, "_on_signed_in"))
	Supabase.auth.connect("signed_up", Callable(self, "on_signed_up"))
	


func update_profile(user_id: String, username : String, email : String, countryid : String):
	print("updating profile")
	print(username)
	print(email)
	var query = SupabaseQuery.new().from("profiles").update({
		username = username,
		email = email,
		country_id = countryid,
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


func sign_in(email: String, password: String):
	print("Signing in...")
	print("Email: " + email)
	print("Password: " + password)
	Supabase.auth.sign_in(
		email,
		password
	)


func _on_signed_in(user: SupabaseUser):
	print("Successfully signed in as ", user)
	get_tree().change_scene_to_file("res://main.tscn")
	FmlAuthService.current_user_id = user.id
	FmlAuthService.current_user_email = user.email
	FmlAuthService.current_user_role = await get_user_role()


var username;
var password;
var email;
var countryid;
func sign_up():
	Supabase.auth.sign_up(
		%SignUpEmailLineEdit.text,
		%SignUpPasswordLineEdit.text
	)
	username = %SignUpUsernameLineEdit.text
	password = %SignUpPasswordLineEdit.text
	email = %SignUpEmailLineEdit.text
	countryid = "HUN"


var newUser;
func on_signed_up(user: SupabaseUser):
	print("Successfully signed up as ", user)
	Supabase.auth.sign_in(
		%SignUpEmailLineEdit.text,
		%SignUpPasswordLineEdit.text
	)
	newUser = user;
	
	%EmailConfirmPanel.visible = true;
	%SignUpPanel.visible = false;


const ROLES = {
	GUEST = 0,
	USER = 1,
	MODERATOR = 2,
	ADMIN = 3,
	SUPER_ADMIN = 4
}

var current_user_id: String = ""  # Stores the logged-in user's UUID
var current_user_email: String = ""
var current_user_role: int = ROLES.GUEST  # Default to guest access


func get_user_role() -> int:
	if current_user_id.is_empty():
		print("No user currently logged in")
		return ROLES.GUEST

	var query = SupabaseQuery.new().from("profiles").select(["role_id"]).eq("id", current_user_id)
	var task = Supabase.database.query(query)
	var result = await task.completed

	if task.error:
		print("Error fetching role: ", task.error.message)
		return ROLES.GUEST

	if not task.data or task.data.size() == 0:
		print("User profile not found")
		return ROLES.GUEST

	current_user_role = task.data[0].get("role_id", ROLES.USER)
	return current_user_role


func is_admin() -> bool:
	return await get_user_role() >= ROLES.ADMIN


func is_moderator() -> bool:
	return await get_user_role() >= ROLES.MODERATOR


func _on_login_button_pressed() -> void:
	print("login")
	sign_in(%LogInEmailLineEdit.text, %LogInPasswordLineEdit.text)


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


func _on_verified_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		%FinishRegistrationButton.disabled == false;
	else:
		%FinishRegistrationButton.disabled == true;

func _on_finish_registration_button_pressed() -> void:
	print("finish reg button pressed")
	sign_in(email, password)
	update_profile(newUser.id, username, email, countryid)
	get_tree().change_scene_to_file("res://main.tscn")
