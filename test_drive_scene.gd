extends Node3D
@onready var kart = $Kart
@export var itemList = ["boost","phase","amogus"]

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("resetKart"):
		$Kart.position = Vector3(-4.871,1.941,-19.26)
		$Kart.rotation = Vector3(0,0,0)
		$Kart.linear_velocity = Vector3(0,0,0)
		$Kart.angular_velocity = Vector3(0,0,0)
		$Kart.inTrack = false
		$Kart.timer = 0
