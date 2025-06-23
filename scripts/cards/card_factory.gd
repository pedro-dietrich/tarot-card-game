class_name CardFactory extends Node

const major_arcana_card_path = preload("res://scenes/major_arcana_card.tscn")

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
	var major_arcana: MajorArcana
	var card: MajorArcanaCard = major_arcana_card_path.instantiate()

	if list_major_arcana.size() > 0:
		var major_arcana_index: int = (randi() % (list_major_arcana.size())) 
		major_arcana = MAJOR_ARCANA_CARD_CLASSES[list_major_arcana[major_arcana_index]].new()
		print("Remove", list_major_arcana[major_arcana_index] )
		list_major_arcana.remove_at(major_arcana_index)
	else:
		major_arcana = fool_arcana()

	card.set_major_arcana(major_arcana)
	return card

func fool_arcana_card() -> MajorArcanaCard:
	var major_arcana: MajorArcana
	var card: MajorArcanaCard = major_arcana_card_path.instantiate()
	major_arcana = fool_arcana()

	card.set_major_arcana(major_arcana)
	return card

func fool_arcana() -> MajorArcana:
	return MAJOR_ARCANA_CARD_CLASSES[0].new()
