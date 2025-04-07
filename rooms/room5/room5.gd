extends Node2D

@export var room_res : Room
@export var connection_point : Node2D

func _ready():
	Signalbus.room_entered.connect(on_room_entered)

func _on_room_entered_area_entered(area):
	print("entered")
	if room_res.room_entered == false:
		room_res.room_entered = true
		print("emit")
		print(Signalbus.room_entered.get_connections())
		Signalbus.room_entered.emit(%Enemies, %Spawns)

func on_room_entered(enemies_parent, spawn_markers_parent):
		room_res.on_room_entered(enemies_parent, spawn_markers_parent)
