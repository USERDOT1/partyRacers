extends Node3D
var itemBoxExists = true
var rot_x = deg_to_rad(50)
var rot_y = deg_to_rad(30)

var waitTime = -1
func _process(delta: float) -> void:
	waitTime -= delta
	if itemBoxExists:
		$BoxMesh/Area3D.monitoring = true
		$BoxMesh.visible = true
		$BoxMesh.rotate_x(rot_x * delta)
		$BoxMesh.rotate_y(rot_y * delta)
	else:
		if waitTime <= 0:
			itemBoxExists = true
		$BoxMesh/Area3D.monitoring = false
		$BoxMesh.visible = false


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.get_parent().identification == "kart":
		area.get_parent().powerup()
		itemBoxExists = false
		waitTime = 5
		$Pickup.play()
