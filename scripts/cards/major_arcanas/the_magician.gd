class_name TheMagician extends MajorArcanaCard

func _init() -> void:
	id = 1
	card_name = "The Magician"


func is_card_playable(target_card: ElementalCard, active_cards: Array[ElementalCard]) -> bool:
	if(active_cards.size() == 0):
		return true

	var card_label: Label3D = target_card.find_child("CardLabel")
	var card_num: int = int(card_label.text.substr(0, 2))

	var last_card_label: Label3D = active_cards[-1].find_child("CardLabel")
	var last_card_num: int = int(last_card_label.text.substr(0, 2))

	return (card_num % 2 != last_card_num % 2)


func bonus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.get_points(active_cards.slice(0, -1))

	if(active_cards.size() <= 1):
		return base_points

	var card_label: Label3D = target_card.find_child("CardLabel")
	var card_num: int = int(card_label.text.substr(0, 2))

	var last_card_label: Label3D = active_cards[-2].find_child("CardLabel")
	var last_card_num: int = int(last_card_label.text.substr(0, 2))

	if(card_num % 2 != last_card_num % 2):
		return 1.5 * base_points
	return base_points
