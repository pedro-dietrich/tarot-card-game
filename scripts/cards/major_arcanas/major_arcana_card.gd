class_name MajorArcanaCard extends Card

var major_arcana: MajorArcana

func set_major_arcana(major_arcana_var):
	major_arcana = major_arcana_var
	$CardLabel.text = major_arcana_var.card_name
	
func set_card_images() -> void:
	var material: Material = ShaderMaterial.new()
	material.shader = load("res://shaders/card.gdshader")
	if(material is ShaderMaterial):
		material.set_shader_parameter("background", load(major_arcana.get_background()))
		material.set_shader_parameter("middleground", load(major_arcana.get_middleground()))
		material.set_shader_parameter("foreground", load(major_arcana.get_foreground()))
		material.set_shader_parameter("base_albedo", load("res://assets/card/card.jpg"))
	$Card.material_override = material
