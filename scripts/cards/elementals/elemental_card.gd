class_name ElementalCard extends Card

func _process(_delta: float) -> void:
	if dragging:
		var hit_info: Dictionary = get_mouse_hit_on_table()
		if hit_info:
			position.x = hit_info.position.x
			position.z = hit_info.position.z

func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			# Comment this part because it does not dissable anything, but with it there is some bug that happen when drawing a new card
			$Card.position.y += DRAG_HEIGHT
			$CardArea3D.collision_layer = 1
		else:
			dragging = false
			$Card.position.y -= DRAG_HEIGHT
			$CardArea3D.collision_layer = 2

# Virtual function to be overridden by the specific cards types
func get_points(_previous_cards: Array[ElementalCard]) -> float:
	push_error("Method get_points() cannot be called on a base elemental card.")
	# TODO NO
	return id


func get_mouse_hit_on_table() -> Dictionary:
	var camera: Camera3D = get_viewport().get_camera_3d()
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var ray_origin: Vector3 = camera.project_ray_origin(mouse_pos)
	var ray_direction: Vector3 = camera.project_ray_normal(mouse_pos)
	var ray_end: Vector3 = ray_origin + 1000.0 * ray_direction

	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var intersect_parameters = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var result: Dictionary = space_state.intersect_ray(intersect_parameters)

	return result
