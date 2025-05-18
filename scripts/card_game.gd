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
var numCardPlayed = 0
var cardPlayed = []

#Node of the card in hand and his id
var cardId = []
var cardNode = []

func _ready() -> void:
	Events.connect("_on_card_played", _on_card_played)
	drawHand()

func _process(_delta: float) -> void:
	#If you played all your card on this level you count your points, see if you win and restart everything
	if (numCardPlayed >= numCardToPlay[level]):
		var points = CountPoints()
		var victory = points - scoreNeeded[level]
		if (victory >= 0 ):
			level += 1
			g.money += victory
		
		#Remove all the instances of the card on the scene
		for card in cardNode:
			remove_child(card)
		
		drawHand()
		cardPlayed = []
		numCardPlayed = 0
		

func drawHand() -> void:
	#Generate the player hand
	cardId = []
	cardNode = []
	#Create a Card node for every card you whould have in hand
	for x in (g.baseNumCard + additionnalCard[level]):
		var newCard = cardPath.instantiate()
		#Variate the z position to have the cards in different places
		var zpos = (x-g.baseNumCard/2.0)*0.25
		newCard.set_position(Vector3(-0.6, 0, zpos))
		newCard.id = x
		
		#Keep in memory which card you have to be able to move/delete them later
		cardNode.append(newCard)
		cardId.append(newCard.id)
		
		add_child(newCard)

func CountPoints() -> int:
	#Will calculate the score obtain on this round
	return 0
	
func _on_card_played(card_id) -> void:
	#A card is played
	print("I'm here")
	#Need to find the node of the card to be able to move it
	var index = cardId.find(card_id, 0)
	var cardToMove = cardNode[index]
	#Keep the position in the hand of the card for the next card
	var position_z = cardToMove.position.z
	
	#Place the card on the table
	cardToMove.position.y = 0
	cardToMove.position.x = 0
	cardToMove.position.z = -1.2 + (numCardPlayed*0.25)
	
	#Save the card you played for the decount later
	numCardPlayed += 1
	cardPlayed.append(card_id)
	#Draw a new card
	#drawOneCard(card_id*10, position_z)
	
func drawOneCard(card_id:int , position_z:float) -> void:
	#Draw a new card
	var newCard = cardPath.instantiate()
	#place the card on the empty position in the hand
	newCard.set_position(Vector3(-0.6, 0, position_z))
	newCard.id = card_id
		
	cardNode.append(newCard)
	cardId.append(newCard.id)
		
	add_child(newCard)
