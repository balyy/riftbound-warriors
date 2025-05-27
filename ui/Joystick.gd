extends Node

var input_vector := Vector2.ZERO
var dragging := false
var radius := 60.0

@onready var base = $JoystickBase
@onready var stick = $JoystickBase/JoystickStick

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		var local_pos = base.get_global_transform().affine_inverse().xform(event.position)
		var center = base.rect_size / 2
		var offset = local_pos - center
		input_vector = offset.clamp_length(radius) / radius

		stick.position = center + input_vector * radius - stick.rect_size / 2
		dragging = event.pressed if event is InputEventScreenTouch else true

	if event is InputEventScreenTouch and not event.pressed:
		input_vector = Vector2.ZERO
		stick.position = base.rect_size / 2 - stick.rect_size / 2
		dragging = false

func get_input_vector() -> Vector2:
	return input_vector
