extends Node3D

@onready var menu_select = preload("res://scenes/menu/shop.tscn")
@onready var credit = preload("res://scenes/menu/credits.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_start_button_button_down() -> void:
	get_tree().change_scene_to_packed(menu_select)

func _on_quit_button_button_down() -> void:
	get_tree().quit()

func _on_credt_button_button_down() -> void:
	get_tree().change_scene_to_packed(credit)
