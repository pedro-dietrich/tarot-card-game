extends MajorArcana

func _init() -> void:
	id = 13
	card_name = "Death"
	arcana_penalty_description = "Cards 1-6 are worth -50%."
	arcana_bonus_effect = "Cards 1-6 are worth +50%."
	
func get_background() -> String:
	return "res://assets/card/major_arcanas/DEATH/1-BG.png"
	
func get_middleground() -> String:
	return "res://assets/card/major_arcanas/DEATH/2-Person.png"

func get_foreground() -> String:
	return "res://assets/card/major_arcanas/DEATH/3-Death/Death Loop_00000.png"


func malus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.element.get_points(active_cards.slice(0, -1))

	var card_num: int = target_card.element.id

	if(card_num < 7):
		return base_points / 2.0
	return base_points


func bonus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	var base_points: float = target_card.element.get_points(active_cards.slice(0, -1))

	var card_num: int = target_card.element.id

	if(card_num < 7):
		return 1.5 * base_points
	return base_points
