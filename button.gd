extends Button


func _ready():
	Supabase.auth.connect("signed_out", Callable(self, "on_logged_out"))


func _on_pressed() -> void:
	Supabase.auth.sign_out()
	


func on_logged_out():
	get_tree().change_scene_to_file("res://ui/auth/auth.tscn")
