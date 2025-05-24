extends Node

#List of the penalties of each arcana when you fight them
const arcana_penalty_effect: Array[String] = [
		"For this round, your hand will be maxed at 3 cards, but, for each turn you will have “infinite” redraw of your entire hand, meaning you discard your hand and draw new cards. If you don’t have any more cards in your hand and deck, the round ends immediately.", 
		"the player need to play a sequence of even and odd cards",
		"Only the earth element have a bonus (other cards are without elements)",
		"First 2 cards are worth -50%",
		"You must finish within +20% of the target",
		"Play only in increasing or decreasing sequence",
		"If you play two cards of the same element in sequence, the second one lose his element bonus",
		"Even cards are worth half",
		"The score of a card is capped at 20",
		"Only wind cards maintain the rule to assign points",
		"X random card are worth 1 point, where X= numCardPlayThisRound/3",
		"Only water cards maintain the rule to assign points",
		"The 10 and heads are worth 1 point instead of 10",
		"Cards 1-6 are worth -50%",
		"Only fire cards maintain the rule to assign points",
		"The value of all cards is hidden",
		"The round ends without the player being able to play the last card of the round",
		"Odd cards are worth half",
		"The elements on the cards are hidden",
		"Target increases by 20%",
		"If the card played has a different element of the one before, the second one lose his elemental bonus",
		"The player has 1 minute to play this round + 10 seconds per card "]

var increasing: int = 0
var randomEffectDone: bool = false

#Function call during the drawing of a card, take card of the penalties that are applied on the hand
func majorAppliedEffectHand(majorPenalty: int, card: Node)-> void :
	var cardLabel: Node = card.find_child("CardLabel")
	var cardNum: String = cardLabel.text[0] + cardLabel.text[1]
	var cardElem: String = cardLabel.text.erase(0, 2)
	#Look which major arcana the player is facing
	match majorPenalty:
		0:
			#TODO: Not yet implemented
			return
		15:
			#Only show the element of the card
			cardLabel.text = cardElem
		18:
			#Only show the value of the card
			cardLabel.text = cardNum
		_ : 
			return

#Function called to apply effect that change value of cards
func majorAppliedToPoint(majorPenalty:int, cardPoint: float, card: Node, cardPlayed: int, lastCard: Node, cardToPlay: int) -> float:
	var cardLabel: Node = card.find_child("CardLabel")
	var cardNum: int = int(cardLabel.text[0] + cardLabel.text[1])
	var cardElem: int = card.id / 14 
	#7 is an afbitrary choice to designate that the last card doesn't exist for now
	var lastCardElem: int = 7
	if(lastCard): lastCardElem = lastCard.id / 14 
		
	#Look which major arcana the player is facing
	match majorPenalty:
		2:
			#If the card is not of the earth element
			if (cardElem != 2): return cardNum
		3:
			#If it is one of the first 2 cards played this round
			if (cardPlayed < 3): return cardPoint/2.0
		6:
			#If the element of the card is the same as the one played before
			if (lastCardElem != 7 and cardElem == lastCardElem): return cardNum
				
		7:
			#If the card is even
			if !(int(cardNum) % 2): return cardPoint*1.5
		8:
			#If the card make you gain more than 20 points
			if (cardPoint > 20): return 20
		9:
			#If the card is not of the wind element
			if (cardElem != 3): return cardNum
		10:
			#If it is the last card you will play this round and you still didn't get a card with onle 1 point
			if (!randomEffectDone and cardToPlay == cardPlayed): return 1
			if (!randomEffectDone ):
				var random: int = randi_range(0,3)
				if (random == 0):
					randomEffectDone = true
					return 1
		11:
			#If the card is not of the water element
			if (cardElem != 1): return cardNum
		12:
			# If the card value is 10 or higher
			if (cardNum > 9): return cardPoint - cardNum + 1.0
		13:
			#If the card value is less than 7
			if (cardNum < 7): return cardPoint/2.0
		14:
			#if the card is not of the fire element
			if (cardElem != 0): return cardNum
		17:
			#If the card is odd
			if (int(cardNum) % 2): return cardPoint/2.0
		20:
			#If the card is not of the same element as the last one
			if ( lastCardElem != 7 and cardElem != lastCardElem): return cardPoint/2.0
		_ : 
			return cardPoint

	return cardPoint

#Func to let you know if the card you choose to play will count or no
func canPlayCard (majorPenalty: int, card: Node, lastCard: Node, cardPlayed: int) -> bool:
	var cardLabel: Node = card.find_child("CardLabel")
	var lastCardLabel: Node = lastCard.find_child("CardLabel") if (lastCard) else null
	var lastCardNum: int = int(lastCardLabel.text[0] + lastCardLabel.text[1]) if lastCardLabel else 0
	var cardNum: int = int(cardLabel.text[0] + cardLabel.text[1])
	
	match majorPenalty:
		1:
			#If the card is of the same parity of the last one
			if (lastCardNum != 0 and cardNum%2 == lastCardNum%2): return false
		5:
			if(cardPlayed > 0):
				if (increasing == 1):
					#If the card has a higher value as the one before
					if (cardNum >= lastCardNum): return false
				elif (increasing == 2):
					#If the card has a value lower has the one before
					if (cardNum <= lastCardNum): return false
				else:
						if (cardNum >= lastCardNum): increasing = 2 #for croissant needed
						else: increasing = 1 #for decreassing needed
		_:
			return true
	
	return true

#Arcana that change the score to obtain
func ScoreToObtain(majorPenalty: int, score: float) -> float:
	match majorPenalty:
		19:
			return score*1.2
		_:
			return score

func newLevel() -> void:
	increasing = 0
	randomEffectDone = false
