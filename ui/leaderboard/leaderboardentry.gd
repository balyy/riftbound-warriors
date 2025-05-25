extends Control

@export var leaderboard_entry_data : leaderboard_entry

func _ready():
	%PlayerNameLabel.text = leaderboard_entry_data.playername
	%ScoreLabel.text = str(leaderboard_entry_data.score)
	%TimeLabel.text = leaderboard_entry_data.time
	%PlacingLabel.text = "#" + str(leaderboard_entry_data.placing)
	%IDLabel.text = str(leaderboard_entry_data.id)
	if await FmlAuthService.is_admin():
		%DeleteButton.visible = true


func delete_leaderboard_entry(entry_id: String) -> void:
	print("Deleting leaderboard entry ID: ", entry_id)
	
	# Since eq() requires String, we'll keep it as string
	var query = SupabaseQuery.new() \
		.from("leaderboard") \
		.delete() \
		.eq("id", entry_id)  # Keep as string
	
	var task = Supabase.database.query(query)
	
	# Handle result with more detailed error checking
	var result = await task.completed
	if task.error:
		print("Deletion failed. Error details:")
		print("Error message: ", task.error.message)
		print("Error code: ", task.error.code)
		print("Error details: ", task.error.details)
	else:
		if typeof(result) == TYPE_ARRAY and result.size() > 0:
			print("Successfully deleted ", result.size(), " entries")
		else:
			print("Delete operation completed but no entries were affected")
			print("Possible reasons:")
			print("- The ID doesn't exist in the database")
			print("- Row Level Security prevents deletion")
			print("- The ID format is incorrect")
	
	Signalbus.fetch_leaderboard.emit()


func _on_delete_button_pressed():
	delete_leaderboard_entry(str(leaderboard_entry_data.id))
