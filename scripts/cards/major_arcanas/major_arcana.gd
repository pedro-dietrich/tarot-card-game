class_name MajorArcana extends Node

var id: int = -1
var card_name: String = "Major Arcana Name"

# Descriptions should be overridden by the derived classes
var arcana_bonus_effect: String = "Major Arcana bonus effect."
var arcana_penalty_description: String = "Major Arcana penalty description."

#func set_card_major_images(path: String) -> void:
	#var material: Material = card_mesh.get_active_material(0)
	#if(material is ShaderMaterial):
		#material.set_shader_parameter("background", load("res://assets/card/major_arcanas/"+path+"background.png"))
		#material.set_shader_parameter("middleground", load("res://assets/card/major_arcanas"+path+"middleground.png"))
		#material.set_shader_parameter("foreground", load("res://assets/card/major_arcanas"+path+"foreground.png"))

func score_to_obtain(score: float) -> float:
	return score

func reset_effects() -> void:
	pass

# Whether the card you choose to play will count or not
func is_card_playable(_target_card: ElementalCard, _active_cards: Array[ElementalCard]) -> bool:
	return true

# Called when drawing a Major Arcana card, take card of the penalties that are applied on the hand
func malus_effect_on_hand(_card: ElementalCard) -> void:
	pass

# Calculates the last played card points, considering the Malus Arcana influence
func malus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	return target_card.element.get_points(active_cards.slice(0, -1))

# Calculates the last played card points, considering the Bonus Arcana influence
func bonus_effect_on_points(active_cards: Array[ElementalCard], _max_active_cards: int) -> float:
	var target_card: ElementalCard = active_cards.back()
	return target_card.element.get_points(active_cards.slice(0, -1))
