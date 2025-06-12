class_name Earth extends Element

func get_points(played_cards: Array[ElementalCard]) -> float:
	return id + 2.0 * played_cards.size() + 2.0
