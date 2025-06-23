class_name TheSun extends MajorArcana

func _init() -> void:
	id = 19
	card_name = "The Sun"


func score_to_obtain(score: float) -> float:
	return 1.2 * score
