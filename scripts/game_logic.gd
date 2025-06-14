extends Node3D

const LVL_MAX_CARDS_PLAYED: Array[int] = [4, 4, 5, 5, 6, 6, 7, 9]
const LVL_TARGET_SCORE: Array[int] = [40, 50, 65, 75, 90, 100, 115, 150]

@onready var basic_card_path = preload("res://scenes/card.tscn")
@onready var button = preload("res://scenes/button.tscn")
@onready var basic_path3D_path = preload("res://scenes/home_path3D.tscn")

var animate_path: AnimatePath = AnimatePath.new()

# Level your currently playing
var level: int = 0
var malus_arcana: MajorArcanaCard = null
var points: float = 0
var last_card_played: ElementalCard = null
var wind_card_count: int = 0 
var deck: Array = range(1, 56) 

var card_factory: CardFactory = CardFactory.new()

var card_move: ElementalCard
var card_move_to: Vector3
var step: Vector3

# Arrays for cards (card node) in the hand, and the round
var hand_cards: Array[ElementalCard] = []
var played_cards: Array[ElementalCard] = []

# TODO: implement card id generation, sequential at the moment
var next_card_id: Array[int] = []

# Distribution of each elements
var fire_cards: Array = range(1,15)
var water_cards: Array = range(15,29)
var earth_cards: Array = range(29,43)
var wind_cards: Array = range(43,57)

# Majors you own and gives you bonuses
var bonus_arcanas: Array[MajorArcanaCard] = []

var lifes: int = 1

func _ready() -> void:
	Events.connect("path_terminate", _on_path_terminate)
	next_malus()
	draw_hand()

func _process(_delta: float) -> void:
	if(level > 6):
		print("Last level not yet implemented.")
		get_tree().reload_current_scene()

	# Check if all cards were played
	var is_tower: int = 1 if(malus_arcana is TheTower) else 0
	if(played_cards.size() < (LVL_MAX_CARDS_PLAYED[level] - is_tower)):
		return

	var target_score: float = malus_arcana.score_to_obtain(LVL_TARGET_SCORE[level])
	if(bonus_arcanas.any(func(bonus: MajorArcanaCard) -> bool: return bonus is TheEmperor)):
		target_score *= 0.9

	var point_balance: float = points - target_score
	if(point_balance < 0.0):
		lifes -= 1
		if(lifes == 0):
			print("\n=== Defeat ===")
			get_tree().reload_current_scene()
	elif(!(malus_arcana is TheEmperor) or points <= 1.2 * target_score):
		level += 1
		g.money += int(point_balance)

		if(malus_arcana is TheSun):
			lifes += 2
		elif(malus_arcana is TheWorld):
			var doubled_arcana_index: int = randi_range(0, bonus_arcanas.size())
			bonus_arcanas.append(bonus_arcanas[doubled_arcana_index])
		else:
			bonus_arcanas.append(malus_arcana)
	print("\nNext level: ", level, " - Lifes: ", lifes)

	# Remove all the instances of the card on the scene
	for card in hand_cards:
		remove_child(card)
		card.queue_free()
	for card in played_cards:
		remove_child(card)
		card.queue_free()

	# Reset round
	next_malus()
	hand_cards = []
	played_cards = []
	next_card_id = []
	draw_hand()
	points = 0
	last_card_played = null
	wind_card_count = 0
	malus_arcana.reset_effects()
	deck = range(1, 56)

func _on_card_played(card_id: int) -> void:
	var index: int = hand_cards.find_custom(func(card: ElementalCard) -> bool: return card.id == card_id)

	if(index == -1):
		print("Card with id '" + var_to_str(card_id) + "' not found in hand")
		return

	var played_card: ElementalCard = hand_cards[index]

	var position_z: float = played_card.position.z
	hand_cards.remove_at(index)

	var card_area_3D: Area3D = played_card.find_child("CardArea3D")
	card_area_3D.collision_layer = 3

	# Verify of the rule of the major arcana authorize this play, if not do not add any point on the board and sacrifice the card
	if(malus_arcana.is_card_playable(played_card, played_cards)):
		play_card(played_card)
	else:
		played_cards.append(played_card)
		played_card.position = Vector3(-70, -70, -70)

	replace_hand()
	draw_card(position_z)


func next_malus() -> void:
	malus_arcana = card_factory.random_major_arcana_card()
	while(bonus_arcanas.has(malus_arcana)):
		malus_arcana = card_factory.random_major_arcana()
	print("Playing level with Major Arcana: ", malus_arcana.card_name)

func replace_hand() -> void:
	for i in range(hand_cards.size()) :
		var card = hand_cards[i]
		var lvl_hand_size: int = g.base_num_card 
		var zpos: float = 0.3 * (i + 1 - ceil(lvl_hand_size / 2.0))
		card.position.z = zpos

# Selects initial cards for the hand
func draw_hand() -> void:
	hand_cards = []
	var lvl_hand_size: int = g.base_num_card 
	for i in lvl_hand_size:
		draw_card()

func draw_card(_position_z = null) -> void:
	var card: ElementalCard = basic_card_path.instantiate()

	# Generate a random id for the card and assure that this id was not already taken by a card this round
	card_factory.assign_random_element_to_card(card, deck)
	next_card_id.append(card.id)

	# Write on the card the number and element
	var card_label: Label3D = card.find_child("CardLabel")
	card_label.text = str(card.element.id)
	card_label.text += card.element.get_label_text()
	
	# Change the hand in function of the Malus Arcana
	malus_arcana.malus_effect_on_hand(card)
	add_card_to_hand(card)

func add_card_to_hand(card: ElementalCard) -> void:
	# Keep in memory which card you have to be able to move/delete them later
	hand_cards.append(card)
	var lvl_hand_size: int = g.base_num_card
	var zpos: float = 0.3 * (hand_cards.size() - ceil(lvl_hand_size / 2.0))
	if(get_tree()):
		animate_path.card_movement(get_tree().current_scene, card, 0.03, zpos, $Deck.position, basic_path3D_path)

func play_card(played_card: ElementalCard) -> void:
	played_card.point = played_card.element.get_points(played_cards)
	played_cards.append(played_card)

	# Change the value of the card depending on the major arcana rule
	played_card.point = malus_arcana.malus_effect_on_points(played_cards, LVL_MAX_CARDS_PLAYED[level])
	for major_bonus in bonus_arcanas:
		played_card.point = major_bonus.bonus_effect_on_points(played_cards, LVL_MAX_CARDS_PLAYED[level])
	points += played_card.point

	last_card_played = played_card
	print("Points: ", points)
	
	var zpos: float = -1.45 + (0.25 * played_cards.size())
	played_card.set_position(Vector3(0, 0, zpos))
	
func _on_path_terminate(card_id: int):
	animate_path._on_path_terminate(get_tree().current_scene, card_id)

func _on_area_3d_area_entered(_area: Node3D) -> void:
	$Area3DDrag/CollisionShape3D/MeshInstance3D.transparency = 0.5

func _on_area_3d_area_exited(_area: Node3D) -> void:
	$Area3DDrag/CollisionShape3D/MeshInstance3D.transparency = 1

func _on_area_3d_play_area_entered(area: Area3D) -> void:
	if("id" in area):
		_on_card_played(area.id)

func _on_area_3d_drag_mouse_exited() -> void:
	Events.emit_signal("_on_drop")
