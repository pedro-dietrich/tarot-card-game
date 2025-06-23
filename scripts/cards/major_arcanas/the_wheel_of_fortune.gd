class_name TheWheelOfFortune extends MajorArcana

var random_effect_done: bool = false

func _init() -> void:
	id = 10
	card_name = "The Wheel of Fortune"


func reset_effects() -> void:
	random_effect_done = false


func malus_effect_on_points(active_cards: Array[ElementalCard], max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.element.get_points(active_cards.slice(0, -1))

	if(random_effect_done):
		return base_points

	if(active_cards.size() == max_active_cards):
		return 1.0
	if(randi_range(0, 3) == 0):
		random_effect_done = true
		return 1.0

	return base_points


func bonus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.element.get_points(active_cards.slice(0, -1))

	if(randi_range(0, 3) == 0):
		return 2.0 * base_points
	return base_points
