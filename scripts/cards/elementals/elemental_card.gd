class_name ElementalCard extends Card

var element: Element
var point: float = 0.0
var place_before_drag: Vector3
var card_in_play_area: bool = false
var card_played: bool = false

func _process(_delta: float) -> void:
	if(dragging):
		var hit_info: Dictionary = get_mouse_hit_on_table()
		if(hit_info):
			position = hit_info.position

func _on_area_3d_input_event(_camera: Camera3D, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if(event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT):
		if(event.pressed):
			dragging = !card_played
			if dragging:
				place_before_drag = position
				rotate_z(-PI/8)
				position.y = 0.2
				$CardArea3D.collision_layer = 1
		else:
			dragging = false
			var change_pos: bool = !card_played
			if(change_pos):
				position.y = 0.1
				rotate_z(PI/8)

				$CardArea3D.collision_layer = 2
				replace_card()

func replace_card() -> void:
	# Wait 0.1 second that the function on the game_logic file get time to finish before doing more
	await get_tree().create_timer(0.1).timeout
	if(!card_played):
		position = place_before_drag

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

func set_card_images() -> void: 
	var material: Material = ShaderMaterial.new()
	material.shader = load("res://shaders/card.gdshader")
	
	if(material is ShaderMaterial):
		var texture = load(element.get_image_path())
		material.set_shader_parameter("background", texture)
		material.set_shader_parameter("middleground", load("res://assets/card/major_arcanas/placeholder/transparent.png"))
		material.set_shader_parameter("foreground", load("res://assets/card/major_arcanas/placeholder/transparent.png"))
		material.set_shader_parameter("base_albedo", load("res://assets/card/card.jpg"))
	
	$Card.material_override = material
