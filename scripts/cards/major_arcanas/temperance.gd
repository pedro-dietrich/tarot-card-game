extends MajorArcanaCard

func _init() -> void:
	id = 14
	card_name = "Temperance"
	arcana_penalty_description = "Only the fire element have a bonus (other cards are without elements)."
	arcana_bonus_effect = "The value of a fire card is doubled."


func malus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.element.get_points(active_cards.slice(0, -1))

	var card_num: int = target_card.element.id

	if(target_card.element is Fire):
		return base_points
	return float(card_num)


func bonus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.element.get_points(active_cards.slice(0, -1))

	if(target_card.element is Fire):
		return 1.5 * base_points
	return base_points
