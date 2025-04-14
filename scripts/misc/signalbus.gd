extends Node

signal room_entered(enemies_parent : Node2D, spawn_markers_parent : Node2D)
signal room_cleared
signal room_load_next
signal player_died(final_score: int, death_date: String)
