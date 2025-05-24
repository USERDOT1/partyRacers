extends RigidBody3D
var startPosition
var startRotation
var playerDirection
var playerForce
func _ready() -> void:
	global_position = startPosition
	global_rotation = startRotation+Vector3(0,deg_to_rad(90),0)
	apply_central_impulse(playerForce)
	apply_central_impulse(playerDirection*15)
