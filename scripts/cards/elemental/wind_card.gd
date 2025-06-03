class_name WindCard extends ElementalCard

func get_points(played_cards: Array[Card]) -> float:
	var wind_card_count: int = 0
	for card in played_cards:
		if card is WindCard:
			wind_card_count += 1

	return (id - 42.0) + 3.0 * fibonacci(wind_card_count)


func fibonacci(n: int) -> int:
	if (n==0): return 0.0
	if (n==1): return 1.0
	return fibonacci(n-1) + fibonacci(n-2)
