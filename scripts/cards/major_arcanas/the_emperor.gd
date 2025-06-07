class_name TheEmperor extends MajorArcanaCard

func _init() -> void:
	id = 4
	card_name = "The Emperor"

func score_to_obtain(score: float) -> float:
	return 0.9 * score
