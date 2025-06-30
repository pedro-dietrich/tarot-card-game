class_name MajorArcanaCard extends Card

var major_arcana: MajorArcana
var material: Material

const TOTAL_FRAMES: int = 24
const ANIMATION_PERIOD: float = 0.1
var frame_timer: float = 0.0
var is_animation_forward: bool = true
var current_frame: int = 0


func set_major_arcana(major_arcana_var):
	major_arcana = major_arcana_var
	$CardLabel.text = major_arcana_var.card_name
	$".".rotate_z(PI/8)
	$".".position = Vector3(-0.4, 0.7, 0)


func set_card_images() -> void:
	material = ShaderMaterial.new()
	material.shader = load("res://shaders/card.gdshader")
	if(material is ShaderMaterial):
		const layers: Array[String] = ["background", "middleground", "foreground"]
		for layer in layers:
			material.set_shader_parameter(layer, load(major_arcana.get_major_images_path() + layer + ".png"))
		material.set_shader_parameter("base_albedo", load("res://assets/card/card.jpg"))
		material.set_shader_parameter("current_frame", current_frame)

	$Card.material_override = material


func _process(delta: float) -> void:
	frame_timer += delta
	if(frame_timer > ANIMATION_PERIOD):
		frame_timer = 0.0
		if is_animation_forward:
			current_frame += 1
			is_animation_forward = current_frame < 23
		else:
			current_frame -= 1
			is_animation_forward = current_frame <= 0

		if(material is ShaderMaterial):
			material.set_shader_parameter("current_frame", current_frame)
