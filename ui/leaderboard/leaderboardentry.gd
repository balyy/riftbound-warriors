extends Control

@export var leaderboard_entry_data : leaderboard_entry

func _ready():
	%PlayerNameLabel.text = leaderboard_entry_data.playername
	%ScoreLabel.text = str(leaderboard_entry_data.score)
	%TimeLabel.text = leaderboard_entry_data.time
	%PlacingLabel.text = "#" + str(leaderboard_entry_data.placing)
