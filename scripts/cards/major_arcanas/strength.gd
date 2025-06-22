extends MajorArcanaCard

func _init() -> void:
	id = 11
	card_name = "Strength"
	arcana_penalty_description = "Only the water element have a bonus (other cards are without elements)."
	arcana_bonus_effect = "The value of a water card is doubled."


func malus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.element.get_points(active_cards.slice(0, -1))

	var card_num: int = target_card.element.id

	if !(target_card.element is Water):
		return base_points
	return float(card_num)


func bonus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.element.get_points(active_cards.slice(0, -1))

	if (target_card.element is Water):
		return 1.5 * base_points
	return base_points
