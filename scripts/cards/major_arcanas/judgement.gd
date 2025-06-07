extends MajorArcanaCard

var sequence: float = 0.0

func _init() -> void:
	id = 20
	card_name = "Judgement"


func reset_effects() -> void:
	sequence = 0.0


func malus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.get_points(active_cards.slice(0, -1))

	if(active_cards.size() > 1 and typeof(target_card) != typeof(active_cards[-2])):
		return base_points / 2.0
	return base_points


func bonus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.get_points(active_cards.slice(0, -1))

	if(active_cards.size() > 1 and typeof(target_card) == typeof(active_cards[-2])):
		sequence += 0.2
		return base_points * (1.0 + sequence)
	return base_points
