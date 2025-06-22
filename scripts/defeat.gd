extends Node3D

@onready var preshop = preload("res://scenes/menu/shop.tscn")

func _on_button_button_down() -> void:
	var shop = load("res://scenes/menu/shop.tscn")
	
	if (shop):
		get_tree().change_scene_to_packed(shop)
	else:
		get_tree().change_scene_to_packed(preshop)
