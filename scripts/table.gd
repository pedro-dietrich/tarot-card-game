extends MeshInstance3D

func _process(delta: float) -> void:
	var rotation_angle: float = delta*0.1
	rotate(Vector3(0, 1, 0), rotation_angle)
