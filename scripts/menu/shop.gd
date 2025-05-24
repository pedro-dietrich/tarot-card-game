extends Control

@onready var startGame = preload("res://scenes/card_game.tscn")

func _process(_delta: float) -> void:
	#Show the amount of money the player currently have
	$Label.text = str(g.money)
	
	#Placeholder for the shop buttons
	$Start.text = "Start"
	$ButtonShop/NumCard.text = str(g.baseNumCard)
	$ButtonShop/HighFire.text = str(g.highFire)
	$ButtonShop/HighWater.text = str(g.highWater)
	$ButtonShop/HighEarth.text = str(g.highEarth)
	$ButtonShop/HighWind.text = str(g.highWind)
	$ButtonShop/RandomMajor.text = str(g.randomMajor)
	$ButtonShop/DiscardCard.text = str(g.discardCard)
	

func _on_num_card_button_() -> void:
	#Purchase on th eupgradding on the number of card in your hand
	if (g.baseNumCard < 6 && g.money >= 20):
		print("I augment the base number of card")
		g.baseNumCard += 1
		g.money -= 20


func _on_high_fire_button_down() -> void:
	#Purchase the high value of the fire element
	if (!g.highFire && g.money >= 30):
		g.highFire = true
		g.money -= 30


func _on_high_water_button_down() -> void:
	#Purchase the high value of the water element
	if (!g.highWater && g.money >= 30):
		g.highWater = true
		g.money -= 30


func _on_high_wind_button_down() -> void:
	#Purchase the high value of the wind element
	if (!g.highWind && g.money >= 30):
		g.highWind = true
		g.money -= 30


func _on_high_earth_button_down() -> void:
	#Purchase the high value of the earth element
	if (!g.highEarth && g.money >= 30):
		g.highEarth = true
		g.money -= 30

func _on_random_major_button_down() -> void:
	#Purchase the posibility to choose the major arcana you'll fight
	if (!g.randomMajor && g.money >= 40):
		g.randomMajor = true
		g.money -= 40

func _on_discard_card_button_down() -> void:
	#Purchase the possibility to discard card
	if (g.discardCard < 3 && g.money >= 50):
		g.discardCard += 1
		g.money -= 50


func _on_start_button_down() -> void:
	#Start the game
	print("Change to the game")
	get_tree().change_scene_to_packed(startGame)
