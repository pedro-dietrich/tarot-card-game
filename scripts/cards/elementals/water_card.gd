class_name WaterCard extends ElementalCard

func get_points(played_cards: Array[ElementalCard]) -> float:
	if played_cards.size() == 0:
		return id - 14.0
	return (id - 14.0) + 0.5 * played_cards.back().get_points()
