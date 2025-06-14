class_name CardFactory extends Node

const ELEMENT_CLASSES: Array[Resource] = [
	preload("res://scripts/cards/elementals/fire.gd"),
	preload("res://scripts/cards/elementals/water.gd"),
	preload("res://scripts/cards/elementals/earth.gd"),
	preload("res://scripts/cards/elementals/wind.gd")
]

const MAJOR_ARCANA_CARD_CLASSES: Array[Resource] = [
	preload("res://scripts/cards/major_arcanas/the_fool.gd"),
	preload("res://scripts/cards/major_arcanas/the_magician.gd"),
	preload("res://scripts/cards/major_arcanas/the_high_priestess.gd"),
	preload("res://scripts/cards/major_arcanas/the_empress.gd"),
	preload("res://scripts/cards/major_arcanas/the_emperor.gd"),
	preload("res://scripts/cards/major_arcanas/the_hierophant.gd"),
	preload("res://scripts/cards/major_arcanas/the_lovers.gd"),
	preload("res://scripts/cards/major_arcanas/the_chariot.gd"),
	preload("res://scripts/cards/major_arcanas/justice.gd"),
	preload("res://scripts/cards/major_arcanas/the_hermit.gd"),
	preload("res://scripts/cards/major_arcanas/the_wheel_of_fortune.gd"),
	preload("res://scripts/cards/major_arcanas/strength.gd"),
	preload("res://scripts/cards/major_arcanas/the_hanged_man.gd"),
	preload("res://scripts/cards/major_arcanas/death.gd"),
	preload("res://scripts/cards/major_arcanas/temperance.gd"),
	preload("res://scripts/cards/major_arcanas/the_devil.gd"),
	preload("res://scripts/cards/major_arcanas/the_tower.gd"),
	preload("res://scripts/cards/major_arcanas/the_star.gd"),
	preload("res://scripts/cards/major_arcanas/the_moon.gd"),
	preload("res://scripts/cards/major_arcanas/the_sun.gd"),
	preload("res://scripts/cards/major_arcanas/judgement.gd"),
	preload("res://scripts/cards/major_arcanas/the_world.gd")
]

func assign_random_element_to_card(card: ElementalCard, deck: Array) -> void:
	var draw_card: int = randi() % deck.size()
	card.id = deck[draw_card]
	deck.remove_at(draw_card)
	
	var card_type_index: int = (card.id - 1) / 14
	card.element = ELEMENT_CLASSES[card_type_index].new()
	
	var card_num:int =  (card.id - 1) % 14
	card.element.id = card_num + 1

# Instantiates a random Major Arcana, not including The Fool
func random_major_arcana_card() -> MajorArcanaCard:
	var major_arcana_index: int = (randi() % (MAJOR_ARCANA_CARD_CLASSES.size() - 1)) + 1
	return MAJOR_ARCANA_CARD_CLASSES[major_arcana_index].new()
