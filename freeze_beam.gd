extends MeshInstance3D


var lifetime  =  4.5



func _process(delta: float) -> void:
	if lifetime > delta:
		lifetime -= delta
	else:
		queue_free()
