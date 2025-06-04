extends Node3D

@onready var menu_select = preload("res://scenes/menu/shop.tscn")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_packed(menu_select)
