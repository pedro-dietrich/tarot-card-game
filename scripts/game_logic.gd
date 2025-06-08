extends Node3D

const LVL_ADDITIONAL_CARDS: Array[int] = [0,0, 0, 1, 1, 1, 2, 2]
const LVL_MAX_CARDS_PLAYED: Array[int] = [4, 4, 5, 5, 6, 6, 7, 9]
const LVL_TARGET_SCORE: Array[int] = [40, 50, 65, 75, 90, 100, 115, 150]

@onready var basic_card_path = preload("res://scenes/card.tscn")
@onready var button = preload("res://scenes/button.tscn")
@onready var basic_path3D_path = preload("res://scenes/home_path3D.tscn")

# Level your currently playing
var level: int = 0
var malus_arcana: MajorArcanaCard = null
var points: float = 0
var last_card_played_points: float = 0
var last_card_played: ElementalCard = null
var wind_card_count: int = 0 

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
var bonus_arcanas: Array[MajorArcanaCard] = [TheDevil.new(), TheMoon.new()]

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
	last_card_played_points = 0
	last_card_played = null
	wind_card_count = 0
	malus_arcana.reset_effects()

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
		var lvl_hand_size: int = g.base_num_card + LVL_ADDITIONAL_CARDS[level]
		var zpos: float = 0.3 * (i + 1 - ceil(lvl_hand_size / 2.0))
		card.position.z = zpos

# Selects initial cards for the hand
func draw_hand() -> void:
	hand_cards = []
	var lvl_hand_size: int = g.base_num_card + LVL_ADDITIONAL_CARDS[level]
	for i in lvl_hand_size:
		draw_card()

func draw_card(_position_z = null) -> void:
	var card: ElementalCard = basic_card_path.instantiate()

	# Generate a random id for the card and assure that this id was not already taken by a card this round
	card.id = randi_range(1, 56)
	while((next_card_id.has(card.id)) and next_card_id.size() < 56):
		card.id = randi_range(1, 56)
	next_card_id.append(card.id)

	print("Card ID is ", card.id)

	# Write on the card the number and element
	var card_label: Label3D = card.find_child("CardLabel")
	card_label.text = str(14 if (card.id % 14 == 0) else card.id % 14)
	if(fire_cards.has(card.id)): card_label.text += " fire"
	elif(water_cards.has(card.id)): card_label.text += " water"
	elif(earth_cards.has(card.id)): card_label.text += " earth"
	elif(wind_cards.has(card.id)): card_label.text += " wind"
	else:
		print("Error, card ID not recognized.")
		get_tree().reload_current_scene()
	# Change the hand in function of the Malus Arcana
	malus_arcana.malus_effect_on_hand(card)
	add_card_to_hand(card)

func add_card_to_hand(card) -> void:
	# Keep in memory which card you have to be able to move/delete them later
	hand_cards.append(card)
	var lvl_hand_size: int = g.base_num_card + LVL_ADDITIONAL_CARDS[level]
	var zpos: float = 0.3 * (hand_cards.size() - ceil(lvl_hand_size / 2.0))
	animate_move(card, -0.6, 0.03, zpos, $Deck.position)


func position_card_in_hand(card) -> void:
	var deck_position: Vector3 = $Deck.position
	card.set_position(deck_position)

func animate_move(card, x, y_start, zpos, base_position) -> void:
	var zinipos: float = base_position.z
	var sign: int = 1 if (zpos < zinipos) else -1
	#the different points that the card will follow
	var zstep: float = sign * (zinipos - zpos) / 100
	var ystep: float = y_start/100
	var zcurve: float = zinipos
	var ycurve: float = y_start
	
	var path3D: Node = basic_path3D_path.instantiate()
	path3D.card_id = card.id
	
	var path_follow3D: Node = path3D.find_child("PathFollow3D")
	
	var curve: Curve3D = Curve3D.new()
	path3D.set_curve(curve)
	while (sign * zcurve > sign * zpos):
		curve.add_point(Vector3(x, ycurve, zcurve))
		zcurve += zstep
		ycurve -= ystep
	
	path_follow3D.add_child(card)
	path_follow3D.get_child_count()
	add_child(path3D)

func play_card(played_card: ElementalCard) -> void:
	last_card_played_points = played_card.get_points(played_cards)
	played_cards.append(played_card)

	# Change the value of the card depending on the major arcana rule
	last_card_played_points = malus_arcana.malus_effect_on_points(played_cards, LVL_MAX_CARDS_PLAYED[level])
	for major_bonus in bonus_arcanas:
		last_card_played_points = major_bonus.bonus_effect_on_points(played_cards, LVL_MAX_CARDS_PLAYED[level])
	points += last_card_played_points

	last_card_played = played_card
	print("Points: ", points)
	
	var zpos: float = -1.45 + (played_cards.size()*0.25)
	played_card.set_position(Vector3(0, 0, zpos))
	#animate_move(played_card, 0, played_card.position.y, zpos, played_card.position)

func _on_path_terminate(card_id: int) -> void:
	var i: int = 0
	var nbchild: int = get_child_count()
	#Find the Path3D child that has emited the signal
	while (i < nbchild and !(get_child(i) is Path3D and get_child(i).card_id == card_id)):
		i += 1
	
	if (i >= nbchild):
		print("path not found")
		return
	
	var path3D: Node = get_child(i)
	var path_follow: Node = path3D.find_child("PathFollow3D")
	var child_index: int = 0
	#Get the card child
	while (child_index < path_follow.get_child_count() and !(path_follow.get_child(child_index) is ElementalCard)):
		child_index += 1
	var card: ElementalCard = path_follow.get_child(child_index) 
	var curve_point: int = path3D.curve.get_point_count()
	#Position the card where it should be
	card.position = path3D.curve.get_point_position(curve_point - 1)
	
	#Remove the card from the child of Path3D and PathFollow3D and remove them from the scene
	path_follow.remove_child(card)
	path3D.remove_child(path_follow)
	path_follow.queue_free()
	remove_child(path3D)
	path3D.queue_free()
	
	#Add the final Card Object
	add_child(card)
	

func _on_area_3d_area_entered(_area: Node3D) -> void:
	$Area3DDrag/CollisionShape3D/MeshInstance3D.transparency = 0.5

func _on_area_3d_area_exited(_area: Node3D) -> void:
	$Area3DDrag/CollisionShape3D/MeshInstance3D.transparency = 1

func _on_area_3d_play_area_entered(area: Area3D) -> void:
	if("id" in area):
		_on_card_played(area.id)

func _on_area_3d_drag_mouse_exited() -> void:
	Events.emit_signal("_on_drop")
