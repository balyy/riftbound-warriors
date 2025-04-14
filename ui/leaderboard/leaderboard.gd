extends Control

@onready var LeaderboardEntriesVBoxContainer = %LeaderboardEntriesVBoxContainer
var LeaderboardEntryScene = preload("res://ui/leaderboard/LeaderboardEntry.tscn")

# Declare signal to emit when the player dies
signal player_died(final_score: int, death_date: String)

# Ensure only one _ready function is defined
func _ready():
	fetch_leaderboard_entries()
	# Connect to the player_died signal (from wherever the player dies)
	# You can replace this with the actual signal from the player class
	connect("player_died", _on_player_died)

func create_leaderboard_entry(user_id: String, time_value: String, score_value: int) -> void:
	print("Creating leaderboard entry...")
	
	var query = SupabaseQuery.new().from("leaderboard").insert([{
		"user_id": user_id,
		"time": time_value, # time as a string like "00:02:15"
		"score": score_value
	}])

	var task = Supabase.database.query(query)
	
	# Otionally handle result
	var result = await task.completed
	if task.error:
		print("Leaderboard entry error: ", task.error.message)
	else:
		print("Leaderboard entry created successfully: ", result)
	
	fetch_leaderboard_entries()

# Function to add the leaderboard entry to the database
func add_leaderboard_entry(time_value: String, score_value: int) -> void:
	# Get the currently logged-in user's ID
	var user_id = Supabase.auth.current_user.id
	
	if user_id == null:
		print("User is not authenticated, cannot add leaderboard entry.")
		return
	
	print("Creating leaderboard entry for user ID: ", user_id)
	
	# Create a new leaderboard entry in the database
	var query = SupabaseQuery.new().from("leaderboard").insert([{
		"user_id": user_id,
		"time": time_value, # time as a string like "2025-04-13 15:30:00"
		"score": score_value
	}])

	# Perform the query
	var task = Supabase.database.query(query)
	
	# Optionally handle the result
	var result = await task.completed
	if task.error:
		print("Leaderboard entry error: ", task.error.message)
	else:
		print("Leaderboard entry created successfully: ", result)

	fetch_leaderboard_entries()
	
# Function to fetch leaderboard entries
func fetch_leaderboard_entries() -> void:
	print("Fetching leaderboard entries...")

	var query = SupabaseQuery.new().from("leaderboard").select(PackedStringArray(["*"])).order("score", true)
	var task = Supabase.database.query(query)
	var result_object = await task.completed

	if task.error:
		print("Error fetching leaderboard entries: ", task.error.message)
		return

	if result_object.data == null:
		print("No leaderboard data returned.")
		return

	print("Fetched leaderboard entries: ", result_object.data)

	# Clear existing entries
	for child in LeaderboardEntriesVBoxContainer.get_children():
		child.queue_free()

	# Iterate through the result_object.data (which is an Array)
	var placing = 0
	for entry_data in result_object.data:
		var entry_res = leaderboard_entry.new()
		entry_res.score = entry_data["score"]
		entry_res.time = entry_data["time"]
		
		placing += 1
		entry_res.placing = placing
		print(placing)

		# Fetch player name from profiles
		entry_res.playername = await fetch_playername(entry_data["user_id"])

		# Instance UI control for this leaderboard entry
		var entry_control = LeaderboardEntryScene.instantiate()
		entry_control.leaderboard_entry_data = entry_res
		LeaderboardEntriesVBoxContainer.add_child(entry_control)

# Fetch playername from the profiles table
func fetch_playername(user_id: String) -> String:
	if not user_id:
		return "Anonymous"

	var query = SupabaseQuery.new().from("profiles").select(PackedStringArray(["username"])).eq("id", user_id)
	var task = Supabase.database.query(query)
	var result = await task.completed

	# Check if the task had an error
	if task.error:
		print("Error fetching playername:", task.error.message)
		return "Unknown"

	# Accessing the actual result data
	var data = task.data

	# Check if no data was returned
	if data.size() == 0:
		print("Could not fetch playername for ", user_id)
		return "Unknown"

	return data[0]["username"]

# The function to be called when the player dies
func _on_player_died(final_score: int, death_date: String) -> void:
	# Pass the final score and current date (death_date) to the add_leaderboard_entry function
	add_leaderboard_entry(death_date, final_score)

# Example of calling the signal from some player class when the player dies
func player_die(final_score: int) -> void:
	# Get the current date in a suitable format, e.g., "2025-04-13 15:30:00"
	var current_date = "2025.04.14"
	emit_signal("player_died", final_score, current_date)


func _on_show_new_entry_panel_button_pressed():
	%NewEntryContainer.visible = true


func _on_cancel_entry_button_pressed():
	%NewEntryContainer.visible = false
	
	
func _on_add_entry_button_pressed():
	create_leaderboard_entry(%UserIdLineEdit.text, %TimeLineEdit.text, int(%ScoreLineEdit.text))
	
