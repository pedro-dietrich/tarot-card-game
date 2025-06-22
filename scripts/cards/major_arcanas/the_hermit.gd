class_name TheHermit extends MajorArcanaCard

func _init() -> void:
	id = 9
	card_name = "The Hermit"
	arcana_penalty_description = "Only the fire element have a bonus (other cards are without elements)"
	arcana_bonus_effect = "the value of a fire card is doubled"


func malus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.element.get_points(active_cards.slice(0, -1))

	var card_num: int = target_card.element.id

	if(target_card.element is Wind):
		return base_points
	return float(card_num)


func bonus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.element.get_points(active_cards.slice(0, -1))

	if(target_card.element is Wind):
		return 1.5 * base_points
	return base_points
