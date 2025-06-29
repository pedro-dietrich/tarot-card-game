class_name MajorArcanaCard extends Card

var major_arcana: MajorArcana

func set_major_arcana(major_arcana_var):
	major_arcana = major_arcana_var
	$CardLabel.text = major_arcana_var.card_name
	$".".rotate_z(PI/8)
	$".".position = Vector3(-0.4, 0.7, 0)


func set_card_images() -> void:
	var material: Material = ShaderMaterial.new()
	material.shader = load("res://shaders/card.gdshader")
	if(material is ShaderMaterial):
		const layers: Array[String] = ["background", "middleground", "foreground"]
		for layer in layers:
			material.set_shader_parameter(layer, load(major_arcana.get_major_images_path() + layer + ".png"))
		material.set_shader_parameter("base_albedo", load("res://assets/card/card.jpg"))

	$Card.material_override = material
