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
var major: int
var points: float = 0
var last_card_played_points:float = 0
var last_card_played: Node = null
var nb_windCard: int = 0 

# Arrays for cards (card node) in the hand, and the round
# TODO: probably, create a class for this, instead of dict
var hand_cards: Array[Node] = []
var played_cards: Array[Node] = []

# TODO: implement card id generation, sequential at the moment
var next_card_id: Array[int] = []

#Distribution of each elements
var fireCards: Array = range(1,15)
var waterCards: Array = range(15,29)
var earthCards: Array = range(29,43)
var windCards: Array = range(43,57)

#Major you own
var majorOwned: Array[int] = []

func _ready() -> void:
	Events.connect("_on_card_double_clicked", _on_card_double_clicked)
	major = randi_range(1,22)
	print("Playing level with:", major)
	draw_hand()

func _process(_delta: float) -> void:
	#If you played all your card on this level you count your points, see if you win and restart everything
	var majorIs16: int = 1 if major == 16 else 0
	if (level > 6):
		print("last level not yet implemented")
		get_tree().reload_current_scene()
	if (played_cards.size() >= (LVL_MAX_CARDS_PLAYED[level] - majorIs16)):
		#print("level is ", level)
		var score: float = MajorArcana.ScoreToObtain(major, LVL_TARGET_SCORE[level])
		var victory = points - score
		print("Total points: '" + var_to_str(points) + "' ")
		print("Score to obtain ", score, " Max score: ", score*1.2)
		if (victory >= 0):
			if !(major == 4 and points > score*1.2):
				#print("You were in the interval")
				level += 1
				print("now you're on level", level)
				g.money += victory
				majorOwned.append(major)
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
		last_card_played_points = 0
		last_card_played = null
		nb_windCard = 0
		major = randi_range(1, 22)
		while (majorOwned.has(major)):
			major = randi_range(1, 22)
		#print("Playing level with:", major)
		
		MajorArcana.newLevel()

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
	#print("card with id '" + var_to_str(card_id) + "' played")

	var position_z: float = played_card.position.z
	hand_cards.remove_at(index)
	#print("The last played card is ", last_card_played)
	
	#Verify of the rule of the major arcana authorize this play, if not do not add any point on the board and sacrifice the card
	var canPlaycard: bool = MajorArcana.canPlayCard(major, played_card, last_card_played, played_cards.size())
	if (canPlaycard):
		play_card(played_card)
	else:
		played_cards.append(played_card)
		played_card.position = Vector3(-70, -70, -70)
	
	draw_card(position_z)

func draw_card(possition_z = null) -> void:
	var card: Node = basicCardPath.instantiate()
	
	#Generate a random id for the card and assure that this id was not already taken by a card this round
	card.id = randi_range(1, 56)
	while (next_card_id.has(card.id)):
		card.id = randi_range(1, 56)
	next_card_id.append(card.id)
	
	#Write on the card the number and element
	var cardLabel: Node = card.find_child("CardLabel")
	cardLabel.text = str(14 if (card.id % 14 == 0)  else card.id%14)
	if (fireCards.has(card.id)):
		cardLabel.text += " fire"
	else :
		if (waterCards.has(card.id)):
			cardLabel.text += " water"
		else:
			if (earthCards.has(card.id)):
				cardLabel.text += " earth"
			else:
				if (windCards.has(card.id)):
					cardLabel.text += " wind"
				else:
					print("Error, id of the card not reconize")
					get_tree().reload_current_scene()
	#Change the hand in function of the major Arcana (For now hide the number or element of a card
	MajorArcana.majorAppliedEffectHand(major, card)
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
	#print("position of the played card" + str(zpos))
	played_card.set_position(Vector3(0, 0, zpos))
	played_cards.append(played_card)
	# Verify the element of the card and count point following the specific rule
	if (fireCards.has(played_card.id)):
		last_card_played_points = 5.0 + played_card.id
	else :
		if (waterCards.has(played_card.id)):
			last_card_played_points = getWaterCardPoints(played_card.id)
		else:
			if (earthCards.has(played_card.id)):
				last_card_played_points = getEarthCardPoints(played_card.id)
			else:
				if (windCards.has(played_card.id)):
					last_card_played_points = getWindCardPoints(played_card.id)
				else:
					print("Error, id of the card not reconize")
					get_tree().reload_current_scene()
	
	#Change the value of the card depending on the major arcana rule
	last_card_played_points = MajorArcana.majorAppliedToPoint(major, last_card_played_points, played_card, played_cards.size(),  last_card_played, LVL_MAX_CARDS_PLAYED[level] )
	points += last_card_played_points
	#remember the last card played
	last_card_played = played_card
	print("points:", points)
	#print("points obtain now:", last_card_played_points)

#Caculate point for water cards
func getWaterCardPoints(cardValue: float) -> float:
	#print("bonus water card:", last_card_played_points * 0.5, "with:", last_card_played_points, "and", (cardValue - 14.0))
	return (cardValue - 14.0) + last_card_played_points*0.5

#Calculate points for earth cards
func getEarthCardPoints(cardValue: float) -> float:
	print(cardValue)
	return (cardValue - 28.0) + 2.0*played_cards.size() 

#Calculate points for wind cards
func getWindCardPoints(cardValue: float) -> float:
	nb_windCard += 1
	print("the value of the card is ", cardValue - 42.0, "and the fibonacci add: ", 3.0*fibonacci(nb_windCard))
	return (cardValue - 42.0) + 3.0*fibonacci(nb_windCard)

#Calculate the fibonacci sequence
func fibonacci(n: int) -> float:
	if (n==0):
		return 0.0
	
	if (n==1):
		return 1.0
	
	return fibonacci(n-1) + fibonacci(n-2)
