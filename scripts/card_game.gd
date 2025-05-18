extends Node3D

@onready var cardPath = preload("res://scenes/card.tscn")

#Additionnal card in your hand, depending on the level
const additionnalCard = [0,0, 0, 1, 1, 1, 2, 2]
#Card you will be able to play depending on the level
const numCardToPlay = [4, 4, 5, 5, 6, 6, 7, 9]
#Score needed to win depending on the level
const scoreNeeded = [40, 50, 65, 75, 90, 100, 115, 150]

#Path to the differents cards to be able to randomly draw them
var cardsPath = []
#Path to the major Arcana to be able to randomly fight them
var majorPath = []

#Level your currently playing
var level = 0
#Card yoou already played this level
var numCardPlayed = 0

# Arrays for cards in the hand, or in the round
var hand_cards = []
var played_cards = []

# TODO: implement card id generation, sequential at the moment
var next_card_id = 0

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
		# TODO: Fix function, card nodes both on hand_cards and played_cards
		#Remove all the instances of the card on the scene
		#for card in hand_cards:
			#remove_child(card)
		drawHand()
		played_cards = []
		numCardPlayed = 0

func drawHand() -> void:
	#Generate the player hand
	hand_cards = []

	#Create a Card node for every card you whould have in hand
	for x in (g.baseNumCard + additionnalCard[level]):
		drawOneCard()

func CountPoints() -> int:
	#Will calculate the score obtain on this round
	return 0

func _on_card_played(card_id) -> void:
	#A card is played
	print("card with id '" + var_to_str(card_id) + "' played")

	# TODO: fix this horrible lambda
	var lamb = func (card): return card["cardId"] == card_id
	var index = hand_cards.find_custom(lamb)

	if index == -1:
		print("card with id '" + var_to_str(card_id) + "' not found in hand")
		return

	var cardToMove = hand_cards[index]
	
	#Remove card from hand, and place the on the table
	hand_cards.remove_at(index)
	put_card_in_played_pos(cardToMove)
	
	#Save the card you played for the decount later
	numCardPlayed += 1
	played_cards.append(cardToMove)
	#Draw a new card
	drawOneCard()
	
func drawOneCard() -> void:
	#Draw a new card
	var newCard = cardPath.instantiate()
	#place the card on the empty position in the hand
	newCard.id = next_card_id
	next_card_id += 1
	#Keep in memory which card you have to be able to move/delete them later
	put_card_in_hand(newCard)

func put_card_in_hand(new_card) -> void:
	var hand_size = hand_cards.size()
	# TODO: validate if zpos logic is enough, how to deal with new drawn card later on
	var zpos = (hand_size-g.baseNumCard/2.0)*0.25
	new_card.set_position(Vector3(-0.6, 0, zpos))

	var hand_card =  {"cardNode": new_card, "cardId": new_card.id}
	hand_cards.append(hand_card)
	add_child(new_card)

func put_card_in_played_pos(card_to_move) -> void:
	var card_to_move_node = card_to_move["cardNode"]
	card_to_move_node.position.y = 0
	card_to_move_node.position.x = 0
	card_to_move_node.position.z = -1.2 + (numCardPlayed*0.25)
