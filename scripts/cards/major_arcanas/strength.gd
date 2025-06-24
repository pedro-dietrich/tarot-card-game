extends MajorArcana

func _init() -> void:
	id = 11
	card_name = "Strength"
	arcana_penalty_description = "Only the cups element has an elemental bonus  (e.g. other cards only punctuate their value)."
	arcana_bonus_effect = "Cups cards are worth 50% more."


func malus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.element.get_points(active_cards.slice(0, -1))

	var card_num: int = target_card.element.id

	if(target_card.element is not Water):
		return base_points
	return float(card_num)


func bonus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.element.get_points(active_cards.slice(0, -1))

	if (target_card.element is Water):
		return 1.5 * base_points
	return base_points
