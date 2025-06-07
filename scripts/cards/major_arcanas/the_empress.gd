class_name TheEmpress extends MajorArcanaCard

func _init() -> void:
	id = 3
	card_name = "The Empress"


func malus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.get_points(active_cards.slice(0, -1))

	if(active_cards.size() < 3):
		return base_points / 2.0
	return base_points


func bonus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.get_points(active_cards.slice(0, -1))

	if(active_cards.size() < 3):
		return 2.0 * base_points
	return base_points
