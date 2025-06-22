class_name TheFool extends MajorArcanaCard

var increase_mode: bool = true

func _init() -> void:
	id = 0
	card_name = "The Fool"
	arcana_penalty_description = "Play only in increasing or decreasing sequence."

func reset_effects() -> void:
	increase_mode = true


func is_card_playable(target_card: ElementalCard, active_cards: Array[ElementalCard]) -> bool:
	if(active_cards.size() == 0):
		return true

	var card_num: int = target_card.element.id
	var last_card_num: int = active_cards[-1].element.id
	
	print("current card num: " + str(card_num))
	print("last card  num: " + str(last_card_num))
	print("for playing in increasing order " + str(increase_mode))
	
	if (active_cards.size() == 1):
		if(card_num >= last_card_num):
			increase_mode = true
		else:
			increase_mode = false
	
	if(!increase_mode && card_num >= last_card_num):
		return false
	elif(increase_mode && card_num <= last_card_num):
		return false

	return true


func bonus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.element.get_points(active_cards.slice(0, -1))

	if(active_cards.size() <= 1):
		return base_points

	var card_num: int = target_card.element.id
	var last_card_num: int = active_cards[-1].element.id

	if(increase_mode && card_num >= last_card_num):
		return 1.5 * base_points
	elif(!increase_mode && card_num <= last_card_num):
		return 1.5 * base_points
	elif(card_num >= last_card_num):
		increase_mode = true
	else:
		increase_mode = false

	return base_points
