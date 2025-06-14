class_name Water extends Element

func get_points(played_cards: Array[ElementalCard]) -> float:
	if played_cards.size() == 0:
		return id
	return id + 0.5 * played_cards.back().element.get_points(played_cards)

func get_label_text() -> String:
	return "Water"
