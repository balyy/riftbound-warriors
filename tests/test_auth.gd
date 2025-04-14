extends "res://addons/gut/test.gd"

var auth

func before_each():
	auth = preload("res://ui/auth/auth.tscn").new()

func test_sign_in_prints_email_and_password():
	var printed = []
	var printer = func(text): printed.append(text)

	# Mock print function
	var original_print = print
	print = printer

	auth.sign_in("test@example.com", "secret123")
	print = original_print

	assert_true("Signing in..." in printed)
	assert_true("Email: test@example.com" in printed)

func test_should_disable_buttons_after_3_failed_attempts():
	var auth = preload("res://ui/auth/auth.tscn").instantiate()
	add_child(auth)

	auth._on_auth_error("wrong password")
	auth._on_auth_error("wrong password")
	auth._on_auth_error("wrong password")

	assert_true(auth.%LogInButton.disabled)
	assert_true(auth.%SignUpButton.disabled)
