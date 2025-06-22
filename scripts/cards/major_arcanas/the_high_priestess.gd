extends MajorArcanaCard

func _init() -> void:
	id = 2
	card_name = "The High Priestess"
	arcana_penalty_description = "Only the earth element have a bonus (other cards are without elements)."
	arcana_bonus_effect = "The value of a earth card is doubled."

func malus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.element.get_points(active_cards.slice(0, -1))

	var card_num: int = target_card.element.id

	if(target_card.element is Earth):
		return base_points
	return float(card_num)


func bonus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.element.get_points(active_cards.slice(0, -1))

	if(target_card.element is Earth):
		return 1.5 * base_points
	return base_points
