class_name MajorArcanaCard extends Card

var major_arcana: MajorArcana

func set_major_arcana(major_arcana_var):
	major_arcana = major_arcana_var
	$CardLabel.text = major_arcana_var.card_name
	
func set_card_images() -> void:
	var material: Material = card_mesh.get_active_material(0)
	if(material is ShaderMaterial):
		material.set_shader_parameter("background", load(major_arcana.get_background()))
		material.set_shader_parameter("middleground", load(major_arcana.get_middleground()))
		material.set_shader_parameter("foreground", load(major_arcana.get_foreground()))
