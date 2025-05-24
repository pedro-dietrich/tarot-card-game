extends Node3D

const LVL_ADDITIONAL_CARDS: Array[int] = [0,0, 0, 1, 1, 1, 2, 2]
const LVL_MAX_CARDS_PLAYED: Array[int] = [4, 4, 5, 5, 6, 6, 7, 9]
const LVL_TARGET_SCORE: Array[int] = [40, 50, 65, 75, 90, 100, 115, 150]

#Path to the differents cards to be able to randomly draw them
var cardsPath: Array = []
#Path to the major Arcana to be able to randomly fight them
var majorPath: Array = []
@onready var basicCardPath = preload("res://scenes/card.tscn")

#Level your currently playing
var level: int = 0
var points: float = 0
var last_card_played:float = 0
var nb_windCard: int = 0

# Arrays for cards (card node) in the hand, and the round
# TODO: probably, create a class for this, instead of dict
var hand_cards: Array[Node] = []
var played_cards: Array[Node] = []

# TODO: implement card id generation, sequential at the moment
var next_card_id: Array[int] = []

func _ready() -> void:
	Events.connect("_on_card_double_clicked", _on_card_double_clicked)
	draw_hand()

func _process(_delta: float) -> void:
	#If you played all your card on this level you count your points, see if you win and restart everything
	if (played_cards.size() >= LVL_MAX_CARDS_PLAYED[level]):
		var victory = points - LVL_TARGET_SCORE[level]
		print("Total points: '" + var_to_str(points) + "' ")
		if (victory >= 0 ):
			level += 1
			g.money += victory
		#Remove all the instances of the card on the scene
		for card in hand_cards:
			remove_child(card)
			card.queue_free()
		for card in played_cards:
			remove_child(card)
			card.queue_free()
		# reset round
		hand_cards = []
		played_cards = []
		next_card_id = []
		draw_hand()
		points = 0
		last_card_played = 0

func draw_hand() -> void:
	#Generate the player hand
	hand_cards = []
	#Create a Card node for every card you whould have in hand
	var lvl_hand_size: int = g.baseNumCard + LVL_ADDITIONAL_CARDS[level]
	for i in (lvl_hand_size):
		draw_card()

func _on_card_double_clicked(card_id) -> void:
	# TODO: fix this horrible lambda
	var lamb = func (card): return card.id == card_id
	var index: int = hand_cards.find_custom(lamb)

	if index == -1:
		print("card with id '" + var_to_str(card_id) + "' not found in hand")
		return

	var played_card: Node = hand_cards[index]
	print("card with id '" + var_to_str(card_id) + "' played")

	var position_z: float = played_card.position.z
	hand_cards.remove_at(index)
	play_card(played_card)
	draw_card(position_z)

func draw_card(possition_z = null) -> void:
	var card: Node = basicCardPath.instantiate()
	card.id = randi_range(1, 56)
	
	while (next_card_id.has(card.id)):
		card.id = randi_range(1, 56)
	next_card_id.append(card.id)
	
	var cardLabel: Node = card.find_child("CardLabel")
	cardLabel.text = str(card.id)
	#card.add_child(cardLabel)
	add_card_to_hand(card, possition_z)

func add_card_to_hand(card, possition_z = null) -> void:
	position_card_in_hand(card, possition_z)
	hand_cards.append(card)
	#Keep in memory which card you have to be able to move/delete them later
	add_child(card)

func position_card_in_hand(card, possition_z) -> void:
	# TODO: validate if zpos logic is enough to position hand cards on table
	var lvl_hand_size: int = g.baseNumCard + LVL_ADDITIONAL_CARDS[level]
	var zpos: float = (hand_cards.size() - lvl_hand_size/2.0)*0.25
	#You need to replace the card on the same spot as the played card
	if (possition_z):
		zpos = possition_z
	
	card.set_position(Vector3(-0.6, 0, zpos))

func play_card(played_card) -> void:
	var zpos: float = -1.2 + (played_cards.size()*0.25)
	print("position of the played card" + str(zpos))
	played_card.set_position(Vector3(0, 0, zpos))
	played_cards.append(played_card)
	# TODO: implement card point system
	var fireCards: Array = range(1,15)
	var waterCards: Array = range(15,29)
	var earthCards: Array = range(29,43)
	var windCards: Array = range(43,57)
	if (fireCards.has(played_card.id)):
		last_card_played = 5.0 + played_card.id
	else :
		if (waterCards.has(played_card.id)):
			last_card_played = getWaterCardPoints(played_card.id)
		else:
			if (earthCards.has(played_card.id)):
				last_card_played = getEarthCardPoints(played_card.id)
			else:
				if (windCards.has(played_card.id)):
					last_card_played = getWindCardPoints(played_card.id)
				else:
					print("Error, id of the card not reconize")
					get_tree().reload_current_scene()
	
	points += last_card_played
	print("points:", points)
	print("points obtain now:", last_card_played)

func getWaterCardPoints(cardValue: float) -> float:
	print("bonus water card:", last_card_played * 0.5, "with:", last_card_played, "and", (cardValue - 14.0))
	return (cardValue - 14.0) + last_card_played*0.5
	
func getEarthCardPoints(cardValue: float) -> float:
	return (cardValue - 28.0) + 2.0*(played_cards.size() - 1) 

func getWindCardPoints(cardValue: float) -> float:
	nb_windCard += 1
	return (cardValue - 42.0) + 3.0*fibonacci(nb_windCard)

func fibonacci(n: int) -> float:
	if (n==0):
		return 0.0
	
	if (n==1):
		return 1.0
	
	return fibonacci(n-1) + fibonacci(n-2)
