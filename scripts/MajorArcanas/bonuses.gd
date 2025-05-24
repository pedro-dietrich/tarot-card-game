extends Node

#List of all bonuses you get by having the major arcana
const arcana_bonus_effect: Array[String] = [
		"No effects", 
		"if 2 cards are played in sequence even/odd, the value of the odd card is doubled",
		"the value of a earth card is doubled",
		"The 2 cards played after this double the value",
		"10% tolerance on the target (if the score to reach is 50, the round can be passed with 45)",
		"if 2 cards are played in a increasing sequence, the points of the second card are doubled",
		"if you two cards of a different element in sequence it gains X*20% in value, where X is the actual sequence of cards with a different element",
		"odd cards are worth 50% more",
		"The score of a card is at a minimum of 10",
		"Gain +50% points for each wind card",
		"Each card played has a ¼ chance of doubling its value",
		"All water cards are worth double",
		"The 1 is worth 10 instead of 1",
		"Cards 1-6 are worth +50%",
		"All fire cards are worth double",
		"The player can choose the value of 1 card",
		"The player can play on more card in the round",
		"Even cards are worth 50% more",
		"The player can choose the element of 1 card ",
		"The player can replay the round 2 times in case of defeat",
		"if you two cards of a different element in sequence it gains X*20% in value, where X is the actual sequence of cards with a different element",
		"The player can double the effect of an arcana"]

var increasing: int = 0
var randomEffectDone: bool = false
var sequence: int = 0
var sequenceSame: int = 0

#Function call during the drawing of a card, take card of the penalties that are applied on the hand
func majorAppliedEffectHandBonus(majorBonus: int, card: Node)-> void :
	var cardLabel: Node = card.find_child("CardLabel")
	var cardNum: String = cardLabel.text[0] + cardLabel.text[1]
	var cardElem: String = cardLabel.text.erase(0, 2)
	#Look which major arcana the player is facing
	match majorBonus:
		15:
			#TODO later, not so easy to implements
			return
		18:
			#TODO later, not so easy to implements
			return
		_ : 
			return

#Function called to apply effect that change value of cards
func majorBonusAppliedToPoint(majorBonus:int, cardPoint: float, card: Node, cardPlayed: int, lastCard: Node, cardToPlay: int) -> float:
	var cardLabel: Node = card.find_child("CardLabel")
	var cardNum: int = int(cardLabel.text[0] + cardLabel.text[1])
	var cardElem: int = card.id / 14 
	#7 is an afbitrary choice to designate that the last card doesn't exist for now
	var lastCardElem: int = 7
	if(lastCard): lastCardElem = lastCard.id / 14 
	var lastCardLabel: Node = lastCard.find_child("CardLabel") if (lastCard) else null
	var lastCardNum: int = int(lastCardLabel.text[0] + lastCardLabel.text[1]) if lastCardLabel else 0
		
	#Look which major arcana the player is facing
	match majorBonus:
		1:
			#If the card is not of the same parity of the last one
			if (lastCardNum != 0 and cardNum%2 != lastCardNum%2): return cardPoint * 1.5
		2:
			#If the card is of the earth element
			if (cardElem == 2): return cardPoint*2.0
		3:
			#If it is one of the first 2 cards played this round
			if (cardPlayed < 3): return cardPoint*2.0
		#If the card are played in an increasing/decreasing sequence
		5:
			if(cardPlayed > 0):
				if (increasing == 1):
					#If the card has a higher value as the one before
					if (cardNum <= lastCardNum): return cardPoint*1.5
				elif (increasing == 2):
					#If the card has a value lower has the one before
					if (cardNum >= lastCardNum): return cardPoint*1.5
				else:
						if (cardNum >= lastCardNum): increasing = 2 #for croissant needed
						else: increasing = 1 #for decreassing needed
		6:
			#If the element of the card is the same as the one played before
			if (lastCardElem != 7 and cardElem == lastCardElem): 
				sequence += 0.2
				return cardPoint * (1.0 + sequence)
		7:
			#If the card is odd
			if (int(cardNum) % 2): return cardPoint*1.5
		8:
			#If the card make you gain more than 20 points
			if (cardPoint < 10): return 10
		9:
			#If the card is of the wind element
			if (cardElem == 3): return cardPoint*1.5
		10:
			#If it is the last card you will play this round and you still didn't get a card with onle 1 point
			var random: int = randi_range(0,3)
			if !(random):
				return cardPoint*2.0
		11:
			#If the card is of the water element
			if (cardElem == 1): return cardNum
		12:
			# If the card value is 10 or higher
			if (cardNum == 1): return cardPoint + 9.0
		13:
			#If the card value is less than 7
			if (cardNum < 7): return cardPoint*1.5
		14:
			#if the card is of the fire element
			if (cardElem == 0): return cardPoint*1.5
		17:
			#If the card is even
			if !(int(cardNum) % 2): return cardPoint*1.5
		20:
			#If the card is not of the same element as the last one
			if ( lastCardElem != 7 and cardElem == lastCardElem): 
				sequenceSame += 0.2
				return cardPoint*(1+sequenceSame)
		_ : 
			return cardPoint

	return cardPoint

#Arcana that change the score to obtain
func ScoreToObtainBonus(majorPenalty: int, score: float) -> float:
	match majorPenalty:
		4:
			return score*0.9
		_:
			return score
