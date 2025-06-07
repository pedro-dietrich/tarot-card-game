class_name TheStar extends MajorArcanaCard

func _init() -> void:
	id = 17
	card_name = "The Star"


func malus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.get_points(active_cards.slice(0, -1))

	var card_label: Label3D = target_card.find_child("CardLabel")
	var card_num: int = int(card_label.text.substr(0, 2))

	if(card_num % 2 == 1):
		return base_points / 2.0
	return base_points


func bonus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.get_points(active_cards.slice(0, -1))

	var card_label: Label3D = target_card.find_child("CardLabel")
	var card_num: int = int(card_label.text.substr(0, 2))

	if(card_num % 2 == 0):
		return 1.5 * base_points

	return base_points
