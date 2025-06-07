class_name TheDevil extends MajorArcanaCard

func _init() -> void:
	id = 15
	card_name = "The Devil"


func malus_effect_on_hand(card: ElementalCard) -> void:
	var card_label: Label3D = card.find_child("CardLabel")
	card_label.text = card_label.text.erase(0, 2)
