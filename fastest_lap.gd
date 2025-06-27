extends Label

func _process(delta: float) -> void:
	if modulate.a < 0:
		queue_free()
	
	modulate.a -= 0.3*delta
	position.y -= 2*delta
