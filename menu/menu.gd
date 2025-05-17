extends Control
@onready var menu_select = preload("res://menu/shop.tscn")
@onready var credits = preload("res://menu/credits.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_start() -> void:
	# Bouton start
	print("Start is pressed")
	get_tree().change_scene_to_packed(menu_select)
	


func _on_button_quit() -> void:
	# Bouton quitter
	print("Quit is pressed")
	get_tree().quit()


func _on_button_credits() -> void:
	# Bouton crédits
	print("Credits is pressed")
	get_tree().change_scene_to_packed(credits)
