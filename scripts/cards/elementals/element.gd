extends Node

class_name  Element

var id: int

# Virtual function to be overridden by the specific cards types
func get_points(_previous_cards: Array[ElementalCard]) -> float:
	push_error("Method get_points() cannot be called on a base elemental card.")
	return 0.0
