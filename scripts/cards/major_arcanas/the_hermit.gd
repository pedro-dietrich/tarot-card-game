class_name TheHermit extends MajorArcana

func _init() -> void:
	id = 9
	card_name = "The Hermit"
	arcana_penalty_description = "Only the swords element has an elemental bonus (e.g. other cards only punctuate their value)."
	arcana_bonus_effect = "Swords cards are worth 50% more."


func get_major_images_path() -> String:
	return "res://assets/card/major_arcanas/the_hermit/"


func malus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.element.get_points(active_cards.slice(0, -1))

	var card_num: int = target_card.element.id

	if(target_card.element is not Wind):
		return float(card_num) 
	return base_points


func bonus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.point

	if(target_card.element is Wind):
		return 1.5 * base_points
	return base_points
