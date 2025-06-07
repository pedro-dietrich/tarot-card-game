extends MajorArcanaCard

func _init() -> void:
	id = 14
	card_name = "Temperance"


func malus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.get_points(active_cards.slice(0, -1))

	var card_label: Label3D = target_card.find_child("CardLabel")
	var card_num: int = int(card_label.text.substr(0, 2))

	if(target_card is FireCard):
		return base_points
	return float(card_num)


func bonus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.get_points(active_cards.slice(0, -1))

	if(target_card is FireCard):
		return 1.5 * base_points
	return base_points
