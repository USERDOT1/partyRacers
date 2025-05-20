extends MeshInstance3D


var lifetime  =  10



func _process(delta: float) -> void:
	if lifetime > delta:
		lifetime -= delta
	else:
		queue_free()
