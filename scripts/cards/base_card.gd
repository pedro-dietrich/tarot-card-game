@icon("res://assets/icons/card_icon.png")
class_name Card extends Node3D

@export var id: int = -1
@export var card_name: String = "Base Card"

@onready var card_mesh: MeshInstance3D = $Card

var dragging: bool = false

# Each child class must override this function with their own card textures
func set_card_images() -> void:
	var material: Material = card_mesh.get_active_material(0)
	if(material is ShaderMaterial):
		material.set_shader_parameter("background", preload("res://assets/card/major_arcanas/placeholder/background.png"))
		material.set_shader_parameter("middleground", preload("res://assets/card/major_arcanas/placeholder/middleground.png"))
		material.set_shader_parameter("foreground", preload("res://assets/card/major_arcanas/placeholder/foreground.png"))

func _ready() -> void:
	$Card/Outline.hide()
	set_card_images()

func _on_area_3d_mouse_entered() -> void:
	$Card/Outline.show()

func _on_area_3d_mouse_exited() -> void:
	$Card/Outline.hide()
