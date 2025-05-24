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
var points: int = 0

# Arrays for cards (card node) in the hand, and the round
# TODO: probably, create a class for this, instead of dict
var hand_cards: Array[Node] = []
var played_cards: Array[Node] = []

# TODO: implement card id generation, sequential at the moment
var next_card_id: int = 0

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
		draw_hand()
		points = 0

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

	var position_z: int = played_card.position.z
	hand_cards.remove_at(index)
	play_card(played_card)
	draw_card(position_z)

func draw_card(possition_z = null) -> void:
	var card: Node = basicCardPath.instantiate()
	card.id = next_card_id
	next_card_id+=1
	add_card_to_hand(card, possition_z)

func add_card_to_hand(card, possition_z = null) -> void:
	position_card_in_hand(card, possition_z)
	hand_cards.append(card)
	#Keep in memory which card you have to be able to move/delete them later
	add_child(card)

func position_card_in_hand(card, possition_z) -> void:
	# TODO: validate if zpos logic is enough to position hand cards on table
	var lvl_hand_size: int = g.baseNumCard + LVL_ADDITIONAL_CARDS[level]
	var zpos: int = (hand_cards.size() - lvl_hand_size/2.0)*0.25
	#You need to replace the card on the same spot as the played card
	if (possition_z):
		zpos = possition_z
	
	card.set_position(Vector3(-0.6, 0, zpos))

func play_card(played_card) -> void:
	var zpos: int = -1.2 + (played_cards.size()*0.25)
	played_card.set_position(Vector3(0, 0, zpos))
	played_cards.append(played_card)
	# TODO: implement card point system
	points += played_card.id
