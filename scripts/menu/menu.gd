extends Control
@onready var menu_select = preload("res://scenes/menu/shop.tscn")
@onready var credits = preload("res://scenes/menu/credits.tscn")

func _on_button_start() -> void:
	# Start Button
	print("Start is pressed")
	get_tree().change_scene_to_packed(menu_select)

func _on_button_quit() -> void:
	# Quit Button 
	print("Quit is pressed")
	get_tree().quit()


func _on_button_credits() -> void:
	# Credits Bouton 
	print("Credits is pressed")
	get_tree().change_scene_to_packed(credits)
