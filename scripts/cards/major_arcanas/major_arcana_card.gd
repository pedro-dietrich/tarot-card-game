class_name MajorArcanaCard extends Card

var major_arcana: MajorArcana

func set_major_arcana(major_arcana_var):
	major_arcana = major_arcana_var
	$CardLabel.text = major_arcana_var.card_name
	set_card_images()

func set_card_images() -> void:
	var material: Material = ShaderMaterial.new()
	material.shader = load("res://shaders/card.gdshader")

	if(material is ShaderMaterial):
		var major_arcana_path = major_arcana.get_arcana_path()
		if(major_arcana_path != ""):
			material.set_shader_parameter("background", load(major_arcana.get_arcana_path()+"_bg.png"))
			material.set_shader_parameter("middleground", load(major_arcana.get_arcana_path()+"_mg.png"))
			material.set_shader_parameter("foreground", load(major_arcana.get_arcana_path()+"_fg.png"))
			material.set_shader_parameter("base_albedo", load("res://assets/card/card.jpg"))
			$Card.material_override = material
