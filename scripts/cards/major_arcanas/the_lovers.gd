class_name TheLovers extends MajorArcana

var sequence: float = 0.0

func _init() -> void:
	id = 6
	card_name = "The Lovers"
	arcana_penalty_description = "If you play two cards of the same type in sequence, the second one loses it's type bonus."
	arcana_bonus_effect = "If you play two cards of a different types in sequence, you gain bonus points."


func get_major_images_path() -> String:
	return "res://assets/card/major_arcanas/the_lovers/"


func reset_effects() -> void:
	sequence = 0.0


func malus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.element.get_points(active_cards.slice(0, -1))

	var card_num: int = target_card.element.id

	if(active_cards.size() > 1 and target_card.element.get_label_text() == active_cards[-2].element.get_label_text()):
		return float(card_num)
	return base_points


func bonus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.point

	if(active_cards.size() > 1 and target_card.element.get_label_text() != active_cards[-2].element.get_label_text()):
		sequence += 0.2
		return base_points * (1.0 + sequence)
	else: sequence = 0.0
	return base_points
