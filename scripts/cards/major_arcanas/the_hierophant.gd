class_name TheHierophant extends MajorArcanaCard

var increase_mode: bool = true

func _init() -> void:
	id = 5
	card_name = "The Hierophant"


func reset_effects() -> void:
	increase_mode = true


func is_card_playable(target_card: ElementalCard, active_cards: Array[ElementalCard]) -> bool:
	if(active_cards.size() == 0):
		return true

	var card_label: Label3D = target_card.find_child("CardLabel")
	var card_num: int = int(card_label.text.substr(0, 2))

	var last_card_label: Label3D = active_cards[-1].find_child("CardLabel")
	var last_card_num: int = int(last_card_label.text.substr(0, 2))

	if(!increase_mode && card_num >= last_card_num):
		return false
	elif(increase_mode && card_num <= last_card_num):
		return false
	elif(card_num >= last_card_num):
		increase_mode = true
	else:
		increase_mode = false

	return true


func bonus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.get_points(active_cards.slice(0, -1))

	if(active_cards.size() <= 1):
		return base_points

	var card_label: Label3D = target_card.find_child("CardLabel")
	var card_num: int = int(card_label.text.substr(0, 2))

	var last_card_label: Label3D = active_cards[-1].find_child("CardLabel")
	var last_card_num: int = int(last_card_label.text.substr(0, 2))

	if(increase_mode && card_num >= last_card_num):
		return 1.5 * base_points
	elif(!increase_mode && card_num <= last_card_num):
		return 1.5 * base_points
	elif(card_num >= last_card_num):
		increase_mode = true
	else:
		increase_mode = false

	return base_points
