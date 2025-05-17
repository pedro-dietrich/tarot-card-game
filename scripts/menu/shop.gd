extends Control

@onready var startGame = preload("res://scenes/menu/shop.tscn")

func _process(_delta: float) -> void:
	$Label.text = str(g.money)
	
	$Start.text = "Start"
	$ButtonShop/NumCard.text = str(g.baseNumCard)
	$ButtonShop/HighFire.text = str(g.highFire)
	$ButtonShop/HighWater.text = str(g.highWater)
	$ButtonShop/HighEarth.text = str(g.highEarth)
	$ButtonShop/HighWind.text = str(g.highWind)
	$ButtonShop/RandomMajor.text = str(g.randomMajor)
	$ButtonShop/DiscardCard.text = str(g.discardCard)
	

func _on_num_card_button_() -> void:
	if (g.baseNumCard < 6 && g.money >= 20):
		print("I augment the base number of card")
		g.baseNumCard += 1
		g.money -= 20


func _on_high_fire_button_down() -> void:
	if (!g.highFire && g.money >= 30):
		g.highFire = true
		g.money -= 30


func _on_high_water_button_down() -> void:
	if (!g.highWater && g.money >= 30):
		g.highWater = true
		g.money -= 30


func _on_high_wind_button_down() -> void:
	if (!g.highWind && g.money >= 30):
		g.highWind = true
		g.money -= 30


func _on_high_earth_button_down() -> void:
	if (!g.highEarth && g.money >= 30):
		g.highEarth = true
		g.money -= 30

func _on_random_major_button_down() -> void:
	if (!g.randomMajor && g.money >= 40):
		g.randomMajor = true
		g.money -= 40

func _on_discard_card_button_down() -> void:
	if (g.discardCard < 3 && g.money >= 50):
		g.discardCard += 1
		g.money -= 50


func _on_start_button_down() -> void:
	get_tree().change_scene_to_packed(startGame)
