@icon("res://assets/icons/card_icon.png")
class_name Card extends Node3D

@export var id: int
@export var card_name: String

var dragging: bool = false
const DRAG_HEIGHT: float = 0.1


func _ready() -> void:
	$Card/Outline.hide()
	$CardArea3D.id = id
	Events.connect("_on_drop", _on_drop)

func _on_drop() -> void:
	print("show")
	if (dragging):
		dragging = false
		$Card.position.y -= DRAG_HEIGHT
		$CardArea3D.collision_layer = 2

func _on_area_3d_mouse_entered() -> void:
	$Card/Outline.show()


func _on_area_3d_mouse_exited() -> void:
	$Card/Outline.hide()

# Virtual function to be overridden by the specific cards types
func get_points(played_cards: Array[Card]) -> float:
	push_error("Method get_points() cannot be called on a base card.")
	return 0.0
