extends Node3D
class_name Card

@export var id: int

const DRAG_HEIGHT: float = 0.1

var dragging: bool = false

func _ready() -> void:
	Events.connect("_on_drop", _on_drop)
	$Card/Outline.hide()
	$CardArea3D.id = id

func _process(_delta: float) -> void:
	if dragging:
		var hit_info: Dictionary = get_mouse_hit_on_table()
		if hit_info:
			position = hit_info.position
	
			
func _on_drop() -> void:
	print("show")
	if (dragging):
		dragging = false
		$Card.position.y -= DRAG_HEIGHT
		$CardArea3D.collision_layer = 2

func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			#Comment this part because it does not dissable anything, but with it there is some bug that happen when drawing a new card
			$Card.position.y += DRAG_HEIGHT
			$CardArea3D.collision_layer = 1
		else:
			dragging = false
			$Card.position.y -= DRAG_HEIGHT
			$CardArea3D.collision_layer = 2
	# When you double_click on a card it emits a signal, which will enable the "play a card" move on the game
	if event is InputEventMouseButton && event.is_double_click():
		_on_card_double_clicked()

func _on_area_3d_mouse_entered() -> void:
	$Card/Outline.show()

func _on_area_3d_mouse_exited() -> void:
	$Card/Outline.hide()

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
	
func _on_card_double_clicked() -> void:
	#Create the emission of the signal
	Events.emit_signal("_on_card_double_clicked", id)
