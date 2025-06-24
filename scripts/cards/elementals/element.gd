class_name Element extends Node

var id: int
var description: String

func get_image_path() -> String:
	return "res://assets/major_arcanas/placeholder/background.png"

# Virtual function to be overridden by the specific cards types
func get_points(_previous_cards: Array[ElementalCard]) -> float:
	push_error("Method get_points() cannot be called on a base elemental card.")
	return 0.0

func get_label_text() -> String:
	return ""
