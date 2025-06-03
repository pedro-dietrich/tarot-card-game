class_name MajorArcanaCard extends Card

# Descriptions should be overridden by the sub-classes
const arcana_penalty_description: String = "Major Arcana penalty description."
const arcana_bonus_effect: String = "Major Arcana bonus effect."

var increasing: int = 0
var random_effect_done: bool = false

func get_points(played_cards: Array[Card]) -> float:
	return 0.0

# Arcana that change the score to obtain
func score_to_obtain(major_penalty: int, score: float) -> float:
	match major_penalty:
		19:
			return 1.2 * score
		_:
			return score

func new_level() -> void:
	increasing = 0
	random_effect_done = false

# Called when drawing a Major Arcana card, take card of the penalties that are applied on the hand
func major_applied_effect_hand(major_penalty: int, card: Node)-> void:
	var card_label: Node = card.find_child("CardLabel")
	var card_num: String = card_label.text[0] + card_label.text[1]
	var card_elem: String = card_label.text.erase(0, 2)
	# Look which major arcana the player is facing
	match major_penalty:
		0:
			# TODO: Not yet implemented
			return
		15:
			# Only show the element of the card
			card_label.text = card_elem
		18:
			# Only show the value of the card
			card_label.text = card_num
		_ : 
			return

# Apply effect that change value of cards
func major_applied_to_point(major_penalty: int, card_point: float, card: Card, card_played: int, last_card: Node, card_to_play: int) -> float:
	var card_label: Node = card.find_child("CardLabel")
	var card_num: int = int(card_label.text[0] + card_label.text[1])
	var card_elem: int = card.id / 14 
	var last_card_elem: int = 7 # 7 is an arbitrary choice to designate that the last card doesn't exist for now
	if(last_card): last_card_elem = last_card.id / 14 
	
	# Look which major arcana the player is facing
	match major_penalty:
		2:
			if(card_elem != 2): return card_num # If the card is not of the earth element
		3:
			# If it is one of the first 2 cards played this round
			if(card_point < 3): return card_point / 2.0
		6:
			# If the element of the card is the same as the one played before
			if(last_card_elem != 7 and card_elem == last_card_elem): return card_num
		7:
			if(int(card_num) % 2 == 0): return card_point / 2.0
		8:
			if(card_point > 20): return 20
		9:
			if(card_elem != 3): return card_num # If the card is not of the wind element
		10:
			# If it is the last card you will play this round and you still didn't get a card with onle 1 point
			if(!random_effect_done and card_to_play == card_played): return 1
			if(!random_effect_done):
				var random: int = randi_range(0,3)
				if(random == 0):
					random_effect_done = true
					return 1
		11:
			# If the card is not of the water element
			if(card_elem != 1): return card_num
		12:
			if(card_num > 9): return card_point - card_num + 1.0
		13:
			if(card_num < 7): return card_point / 2.0
		14:
			if(card_elem != 0): return card_num # If the card is not of the fire element
		17:
			if(int(card_num) % 2): return card_point / 2.0
		20:
			# If the card is not of the same element as the last one
			if(last_card_elem != 7 and card_elem != last_card_elem): return card_point/2.0
		_ : 
			return card_point
	
	return card_point

# Whether the card you choose to play will count or not
func can_play_card(major_penalty: int, card: Card, last_card: Card, card_played: int) -> bool:
	var card_label: Node = card.find_child("CardLabel")
	var last_card_label: Node = last_card.find_child("CardLabel") if (last_card) else null
	var last_card_num: int = int(last_card_label.text[0] + last_card_label.text[1]) if last_card_label else 0
	var card_num: int = int(card_label.text[0] + card_label.text[1])
	
	match major_penalty:
		1:
			# If the card is of the same parity of the last one
			if (last_card_num != 0 and card_num % 2 == last_card_num % 2): return false
		5:
			if(card_played > 0):
				if(increasing == 1):
					# If the card has a higher value as the one before
					if (card_num >= last_card_num): return false
				elif(increasing == 2):
					# If the card has a value lower has the one before
					if(card_num <= last_card_num): return false
				elif(card_num >= last_card_num):
					increasing = 2 # For croissant needed
				else:
					increasing = 1 # For decreasing needed
		_:
			return true
	
	return true
