class_name Level extends Node
 
const LVL_MAX_CARDS_PLAYED: Array[int] = [4, 4, 5, 5, 6, 6, 7, 9]
const LVL_TARGET_SCORE: Array[int] = [40, 50, 65, 75, 90, 100, 115, 150]
const LAST_LEVEL: int = 3

var level: int = 0
var malus_arcana_card: MajorArcanaCard = null
var alternate_malus_arcana: MajorArcanaCard = null
var points: float = 0
var last_card_played: ElementalCard = null
var wind_card_count: int = 0 
var target_score: float = 0

func get_malus_arcana():
	return malus_arcana_card.major_arcana

func is_last_level():
	return level == LAST_LEVEL

func is_game_won():
	return level > LAST_LEVEL

func update_target_score():
	target_score = get_malus_arcana().score_to_obtain(LVL_TARGET_SCORE[level])

func is_end_of_round(played_cards: Array[ElementalCard]) -> bool:
	# Check if all cards were played
	var is_tower: int = 1 if(get_malus_arcana() is TheTower) else 0

	return played_cards.size() >= (LVL_MAX_CARDS_PLAYED[level] - is_tower)

func is_round_won(bonus_arcanas: Array[MajorArcanaCard]) -> bool:
	# TODO: is this code still needed? Should the update_target_score change the score before?
	if(bonus_arcanas.any(func(bonus: MajorArcanaCard) -> bool: return bonus.major_arcana is TheEmperor)):
		target_score *= 0.9
	if (get_malus_arcana() is TheEmperor):
		target_score *= 1.2

	return points > target_score

func reset() -> void:
	points = 0
	last_card_played = null
	wind_card_count = 0
	get_malus_arcana().reset_effects()
	malus_arcana_card.position = Vector3(-0.6, 0, 0.5 + level * 0.25)
	
func increment() -> void:
	level += 1
	var point_balance: float = points - target_score
	g.money += int(point_balance)

func get_card_points(played_card: ElementalCard, played_cards, bonus_arcanas):
	# Change the value of the card depending on the major arcana rule
	played_card.point = get_malus_arcana().malus_effect_on_points(played_cards, LVL_MAX_CARDS_PLAYED[level])
	for major_bonus in bonus_arcanas:
		played_card.point = major_bonus.major_arcana.bonus_effect_on_points(played_cards, LVL_MAX_CARDS_PLAYED[level])
	
	points += played_card.point
	last_card_played = played_card
	print("Points: ", points)
