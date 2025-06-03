extends ElementalCard

func get_points(played_cards: Array[Card]) -> float:
	return (id - 28.0) + 2.0 * played_cards.size()
