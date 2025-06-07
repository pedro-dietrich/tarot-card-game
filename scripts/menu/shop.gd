extends Control

@onready var start_game = preload("res://scenes/card_game.tscn")

func _process(_delta: float) -> void:
	# Show the amount of money the player currently have
	$Label.text = str(g.money)
	
	# Placeholder for the shop buttons
	$Start.text = "Start"
	$ButtonShop/NumCard.text = str(g.base_num_card)
	$ButtonShop/HighFire.text = str(g.high_fire)
	$ButtonShop/HighWater.text = str(g.high_water)
	$ButtonShop/HighEarth.text = str(g.high_earth)
	$ButtonShop/HighWind.text = str(g.high_wind)
	$ButtonShop/RandomMajor.text = str(g.random_major)
	$ButtonShop/DiscardCard.text = str(g.discard_card)

# Purchase an upgrade to the value of a card in hand
func _on_num_card_button_() -> void:
	if(g.base_num_card < 6 && g.money >= 20):
		print("Card value upgraded.")
		g.base_num_card += 1
		g.money -= 20

# Purchase the high value of the fire element
func _on_high_fire_button_down() -> void:
	if(!g.high_fire && g.money >= 30):
		g.high_fire = true
		g.money -= 30

# Purchase the high value of the water element
func _on_high_water_button_down() -> void:
	if(!g.high_water && g.money >= 30):
		g.high_water = true
		g.money -= 30

# Purchase the high value of the wind element
func _on_high_wind_button_down() -> void:
	if(!g.high_wind && g.money >= 30):
		g.high_wind = true
		g.money -= 30

# Purchase the high value of the earth element
func _on_high_earth_button_down() -> void:
	if(!g.high_earth && g.money >= 30):
		g.high_earth = true
		g.money -= 30

# Purchase the possibility to choose the Major Arcana you'll fight
func _on_random_major_button_down() -> void:
	if(!g.random_major && g.money >= 40):
		g.random_major = true
		g.money -= 40

# Purchase the possibility to discard a card
func _on_discard_card_button_down() -> void:
	if (g.discard_card < 3 && g.money >= 50):
		g.discard_card += 1
		g.money -= 50

# Starts the game
func _on_start_button_down() -> void:
	print("Change to the game.")
	get_tree().change_scene_to_packed(start_game)
