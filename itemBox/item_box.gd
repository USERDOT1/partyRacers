extends Node3D
var itemBoxExists = true
var rot_x = deg_to_rad(50)
var rot_y = deg_to_rad(30)

func _process(delta: float) -> void:
	
	if itemBoxExists:
		$BoxMesh.rotate_x(rot_x * delta)
		$BoxMesh.rotate_y(rot_y * delta)


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.get_parent().identification == "kart":
		area.get_parent().powerup()
		$BoxMesh.queue_free()
		itemBoxExists = false
		$Pickup.play()
