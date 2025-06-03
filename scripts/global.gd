extends Node

# Player's money
var money: int = 200

# Number of card in your hand at the start of the round
var baseNumCard: int  = 3

# Bool for available strengthening on the shop
var highFire: bool = false
var highWater: bool = false
var highWind: bool = false
var highEarth: bool = false
var randomMajor: bool = false

# Integer to know how much time did the player purchase this strengthening (number of cards to discard = 5*discardCard)
var discardCard: int  = 0
