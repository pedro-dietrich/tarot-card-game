class_name ElementalCard extends Card

var element: Element
var point: float = 0.0
var place_before_drag: Vector3
var card_in_play_area: bool = false
var card_played: bool = false

#func _ready() -> void:
	#Events.connect("_on_entered", _on_entered)
	#Events.connect("_on_exit", _on_exit)
	
func _process(_delta: float) -> void:
	if dragging:
		var hit_info: Dictionary = get_mouse_hit_on_table()
		if hit_info:
			position = hit_info.position

func _on_area_3d_input_event(camera: Camera3D, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			
			place_before_drag = position
			rotate_z(-PI/8)
			position.y = 0.2
			$CardArea3D.collision_layer = 1
		else:
			dragging = false
			position.y = 0.1
			rotate_z(PI/8)
			
			$CardArea3D.collision_layer = 2
			#if (!card_in_play_area):
				#position = place_before_drag
			#else:
				#card_played = true
			
			

#func _on_entered() -> void:
	#card_in_play_area = true
	#
#func _on_exit() -> void:
	#card_in_play_area = false

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
