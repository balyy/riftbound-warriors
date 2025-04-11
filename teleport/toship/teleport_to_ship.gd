extends Node2D

@export var TeleportTo : Vector2

func _on_area_2d_area_entered(area):
	%RiftboundWarrior.global_position = TeleportTo
