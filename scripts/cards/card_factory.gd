class_name CardFactory extends Node

const ELEMENT_CLASSES: Array[Resource] = [
	preload("res://scripts/cards/elementals/fire_card.gd"),
	preload("res://scripts/cards/elementals/water_card.gd"),
	preload("res://scripts/cards/elementals/earth_card.gd"),
	preload("res://scripts/cards/elementals/wind_card.gd")
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

func random_elemental_card(card: ElementalCard, next_card_id: Array[int]) -> void:
	var card_type_index: int = randi() % ELEMENT_CLASSES.size()
	card.element = ELEMENT_CLASSES[card_type_index].new()
	
	var card_num:int = randi() % 14 + 1 
	card.element.id = card_num
	card.id = card_num + card_type_index * 14
	
	while((next_card_id.has(card.id)) and next_card_id.size() < 56):
		random_elemental_card(card, next_card_id)

# Instantiates a random Major Arcana, not including The Fool
func random_major_arcana_card() -> MajorArcanaCard:
	var major_arcana_index: int = (randi() % (MAJOR_ARCANA_CARD_CLASSES.size() - 1)) + 1
	return MAJOR_ARCANA_CARD_CLASSES[major_arcana_index].new()
