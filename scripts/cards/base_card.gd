@icon("res://assets/icons/card_icon.png")
class_name Card extends Node3D

@export var id: int = -1
@export var card_name: String = "Base Card"

var dragging: bool = false

func _ready() -> void:
	$Card/Outline.hide()
	$CardArea3D.id = id

func _on_area_3d_mouse_entered() -> void:
	$Card/Outline.show()

func _on_area_3d_mouse_exited() -> void:
	$Card/Outline.hide()
