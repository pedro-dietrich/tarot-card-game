extends Node3D

@onready var cardPath = preload("res://scenes/card.tscn")

#Additionnal card in your hand, depending on the level
var additionnalCard = [0,0, 0, 1, 1, 1, 2, 2]
#Card you will be able to play depending on the level
var numCardToPlay = [4, 4, 5, 5, 6, 6, 7, 9]
#Score needed to win depending on the level
var scoreNeeded = [40, 50, 65, 75, 90, 100, 115, 150]
#Path to the differents cards to be able to randomly draw them
var cardsPath = []
#Path to the major Arcana to be able to randomly fight them
var majorPath = []

#Level your currently playing
var level = 0
#Card yoou already played this level
var cardPlayed = 0

func _ready() -> void:
	#Create a Card node for every card you whould have in hand
	for x in (g.baseNumCard + additionnalCard[level]):
		var newCard = cardPath.instantiate()
		var zpos = (x-g.baseNumCard/2)*0.25
		newCard.set_position(Vector3(-0.6, 0, zpos))
		newCard.position.y= 0
		add_child(newCard)
