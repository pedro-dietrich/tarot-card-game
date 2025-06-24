extends Node3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_packed(load("res://scenes/menu/menu.tscn"))


func _on_button_button_down() -> void:
	print("button clicked")
	get_tree().change_scene_to_packed(load("res://scenes/menu/menu.tscn"))
