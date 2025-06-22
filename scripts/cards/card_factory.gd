class_name CardFactory extends Node

const ELEMENT_CLASSES: Array[Resource] = [
	preload("res://scripts/cards/elementals/fire.gd"),
	preload("res://scripts/cards/elementals/water.gd"),
	preload("res://scripts/cards/elementals/earth.gd"),
	preload("res://scripts/cards/elementals/wind.gd")
]

const MAJOR_ARCANA_CARD_CLASSES: Array[Resource] = [
	preload("res://scripts/cards/major_arcanas/the_fool.gd"),
	preload("res://scripts/cards/major_arcanas/the_high_priestess.gd"),
	preload("res://scripts/cards/major_arcanas/the_lovers.gd"),
	preload("res://scripts/cards/major_arcanas/the_hermit.gd"),
	preload("res://scripts/cards/major_arcanas/strength.gd"),
	preload("res://scripts/cards/major_arcanas/death.gd"),
	preload("res://scripts/cards/major_arcanas/temperance.gd")
]

func assign_random_element_to_card(card: ElementalCard, deck: Array) -> void:
	var draw_card: int = randi() % deck.size()
	card.id = deck[draw_card]
	deck.remove_at(draw_card)

	var card_type_index: int = int((card.id - 1) / 14)
	card.element = ELEMENT_CLASSES[card_type_index].new()

	var card_num: int = (card.id - 1) % 14
	card.element.id = card_num + 1

# Instantiates a random Major Arcana, not including The Fool
func random_major_arcana_card(list_major_arcana: Array) -> MajorArcanaCard:
	if list_major_arcana.size() > 0:
		var major_arcana_index: int = (randi() % (list_major_arcana.size())) 
		var major_arcana: MajorArcanaCard = MAJOR_ARCANA_CARD_CLASSES[list_major_arcana[major_arcana_index]].new()
		
		print("Remove", list_major_arcana[major_arcana_index] )
		list_major_arcana.remove_at(major_arcana_index)
		return major_arcana
	return MAJOR_ARCANA_CARD_CLASSES[0].new()
	
func fool_arcana_card() -> MajorArcanaCard:
	return MAJOR_ARCANA_CARD_CLASSES[0].new()
