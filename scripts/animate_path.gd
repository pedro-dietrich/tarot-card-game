extends Node

class_name AnimatePath

var sample = 100

#Generate the animation of the card from y_start to 0 and base_position.z to e_end in a direct line
func card_movement(game_scene: Node3D, card: Card, y_start: float, z_end: float, base_position: Vector3, basic_path3D_path) -> void:
	var z_start: float = base_position.z
	var pos_sign: int = 1 if (z_end < z_start) else -1
	# The different points that the card will follow
	var zstep: float = pos_sign * (z_start - z_end) / sample
	var ystep: float = y_start / sample
	var zcurve: float = z_start
	var ycurve: float = y_start

	var path3D: Path3D = basic_path3D_path.instantiate()
	card.rotation = Vector3(PI, PI, 0)
	path3D.card_id = card.id

	var path_follow3D: PathFollow3D = path3D.find_child("PathFollow3D")

	var curve: Curve3D = Curve3D.new()
	path3D.set_curve(curve)
	while(pos_sign * zcurve > pos_sign * z_end):
		curve.add_point(Vector3(base_position.x, ycurve, zcurve))
		zcurve += zstep
		ycurve -= ystep

	path_follow3D.add_child(card)
	path_follow3D.get_child_count()
	game_scene.add_child(path3D)

func _on_path_terminate(game_scene: Node3D, card_id: int) -> void:
	var i: int = 0
	var child_count: int = game_scene.get_child_count()
	# Find the Path3D child that has emited the signal
	while(i < child_count and !(game_scene.get_child(i) is Path3D and game_scene.get_child(i).card_id == card_id)):
		i += 1

	if(i >= child_count):
		print("Path not found.")
		return

	var path3D: Path3D = game_scene.get_child(i)
	var path_follow: PathFollow3D = path3D.find_child("PathFollow3D")
	var child_index: int = 0
	# Get the card child
	while(child_index < path_follow.get_child_count() and !(path_follow.get_child(child_index) is ElementalCard)):
		child_index += 1
	var card: ElementalCard = path_follow.get_child(child_index) 
	var curve_point: int = path3D.curve.get_point_count()
	# Position the card where it should be
	card.position = path3D.curve.get_point_position(curve_point - 1)

	# Remove the card from the child of Path3D and PathFollow3D and remove them from the scene
	path_follow.remove_child(card)
	path3D.remove_child(path_follow)
	path_follow.queue_free()
	game_scene.remove_child(path3D)
	path3D.queue_free()

	# Add the final Card Object
	game_scene.add_child(card)
