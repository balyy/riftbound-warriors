extends Node2D


func _on_button_left_pressed() -> void:
	$BallAndChainRobot.scale.x = -1


func _on_button_right_pressed() -> void:
	$BallAndChainRobot.scale.x = 1
