extends Node3D

@onready var start_game = preload("res://scenes/card_game.tscn")

func _ready() -> void:
	if g.random_major: $CanvasLayer/ButtonShop/RandomArcana.hide()
	if g.base_num_card >= 6: $CanvasLayer/ButtonShop/Label.hide()

func _process(_delta: float) -> void:
	# Show the amount of money the player currently have
	$CanvasLayer/Label.text = str(g.money)
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_packed(load("res://scenes/menu/menu.tscn"))

# Purchase an upgrade to the value of a card in hand
func _on_num_card_button_() -> void:
	if(g.base_num_card < 6 && g.money >= 20):
		print("Card value upgraded.")
		g.base_num_card += 1
		g.money -= 20
		if (g.base_num_card >= 6): $CanvasLayer/ButtonShop/Label.hide()

# Purchase the possibility to choose the Major Arcana you'll fight
func _on_random_major_button_down() -> void:
	if(!g.random_major && g.money >= 40):
		g.random_major = true
		g.money -= 40
		$CanvasLayer/ButtonShop/RandomArcana.hide()

# Starts the game
func _on_start_button_down() -> void:
	print("Change to the game.")
	get_tree().change_scene_to_packed(start_game)
