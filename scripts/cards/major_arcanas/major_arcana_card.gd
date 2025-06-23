class_name MajorArcanaCard extends Card

var major_arcana: MajorArcana

func _ready() -> void:
	pass

func set_major_arcana(major_arcana_var):
	major_arcana = major_arcana_var
	$CardLabel.text = major_arcana_var.card_name
