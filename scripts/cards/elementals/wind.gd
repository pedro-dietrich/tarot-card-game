class_name Wind extends Element

func get_points(played_cards: Array[ElementalCard]) -> float:
	var wind_card_count: int = 0
	for card in played_cards:
		if card.element is Wind:
			wind_card_count += 1

	return id + 3.0 * fibonacci(wind_card_count)


func fibonacci(n: int) -> int:
	if(n == 0 or n == 1): return 1
	if(n < 0): return 0
	return fibonacci(n - 1) + fibonacci(n - 2)
	
func get_label_text() -> String:
	return "Wind"
