extends Node2D


func _on_new_point_timer_timeout() -> void:
	%PathFollow2D.progress_ratio = randf() # Chooses a random point around the player
	self.global_position = %PathFollow2D.global_position
