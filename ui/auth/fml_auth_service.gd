extends Node
class_name AuthService

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
