extends Node

# Player's money
var money: int = 200

# Number of card in your hand at the start of the round
var base_num_card: int  = 3

# Bool for available strengthening on the shop
var high_fire: bool = false
var high_water: bool = false
var high_wind: bool = false
var high_earth: bool = false
var random_major: bool = false

# Integer to know how much time did the player purchase this strengthening (number of cards to discard = 5*discardCard)
var discard_card: int  = 0
