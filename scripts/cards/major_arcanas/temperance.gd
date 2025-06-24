extends MajorArcana

func _init() -> void:
	id = 14
	card_name = "Temperance"
	arcana_penalty_description = "Only the wands element has an elemental bonus  (e.g. other cards only punctuate their value)."
	arcana_bonus_effect = "Wands cards are worth 50% more."


func malus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.element.get_points(active_cards.slice(0, -1))

	var card_num: int = target_card.element.id

	if(target_card.element is not Fire):
		return float(card_num)  
	return base_points


func bonus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.element.get_points(active_cards.slice(0, -1))

	if(target_card.element is Fire):
		return 1.5 * base_points
	return base_points
