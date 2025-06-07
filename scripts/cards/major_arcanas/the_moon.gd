class_name TheMoon extends MajorArcanaCard

func _init() -> void:
	id = 18
	card_name = "The Moon"


func malus_effect_on_hand(card: ElementalCard) -> void:
	var card_label: Label3D = card.find_child("CardLabel")
	card_label.text = card_label.text.substr(0, 2)
