extends Node

##The money the player have
var money = 200

##Number of card in your hand at the start of the round
var baseNumCard = 3

##Bool for strenghening disponible on the shop
var highFire = false
var highWater = false
var highWind  = false
var highEarth = false
var randomMajor = false

##int to be able to know how much time did the player purchase this strengthening (number of card to discard = 5*discardCard)
var discardCard = 0
