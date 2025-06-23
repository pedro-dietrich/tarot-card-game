extends Node3D

@onready var elemental_card_path = preload("res://scenes/elemental_card.tscn")
@onready var button = preload("res://scenes/button.tscn")
@onready var menu_select = preload("res://scenes/menu/shop.tscn")
@onready var basic_path3D_path = preload("res://scenes/home_path3D.tscn")
@onready var victory_screen = preload("res://scenes/victory.tscn")
@onready var defeat_screen = preload("res://scenes/defeat.tscn")

var animate_path: AnimatePath = AnimatePath.new()

# Level your currently playing
var level: Level = Level.new()

var card_factory: CardFactory = CardFactory.new()

var card_move: ElementalCard
var card_move_to: Vector3
var step: Vector3

# Arrays for cards (card node) in the hand, and the round
var hand_cards: Array[ElementalCard] = []
var played_cards: Array[ElementalCard] = []

# TODO: implement card id generation, sequential at the moment
var next_card_id: Array[int] = []

# Majors you own and gives you bonuses
var bonus_arcanas: Array[MajorArcanaCard] = []

var deck: Array = range(1, 57)
var list_major_arcana: Array = range(1, 7)

# State machine logic
enum {STATE_INTRO, STATE_CHOOSE_MALUS, STATE_WAIT_START_CONFIRM, STATE_MAIN, STATE_OUTRO, STATE_WAIT_END_CONFIRM}
var current_state = STATE_INTRO

var lifes: int = 1

func _ready() -> void:
	current_state = STATE_INTRO
	Events.connect("path_terminate", _on_path_terminate)

func _process(_delta: float) -> void:
	match current_state:
		STATE_INTRO:
			if(level.is_game_won()):
				print("Game already won.")
				get_tree().reload_current_scene()
			next_malus()
			level.update_target_score()
			if (g.random_major):
				current_state = STATE_CHOOSE_MALUS
				$CanvasLayer/Overlay.write_choose_labels(level)
			else:
				$CanvasLayer/Overlay.write_intro_labels(level)
				current_state = STATE_WAIT_START_CONFIRM
			add_child(level.malus_arcana_card)
			print("Playing level with Major Arcana: ", level.get_malus_arcana().card_name)

		STATE_CHOOSE_MALUS:
			if ($CanvasLayer/Overlay.major_chosen > 0):
				change_major()
				$CanvasLayer/Overlay.write_intro_labels(level)
				current_state = STATE_WAIT_START_CONFIRM

		STATE_WAIT_START_CONFIRM:
			if(Input.is_action_just_pressed("ui_accept")):
				draw_hand()
				$CanvasLayer/Overlay.set_labels(level.get_malus_arcana().card_name)
				current_state = STATE_MAIN

		STATE_MAIN:
			if(level.is_end_of_round(played_cards)):
				if(level.is_round_won(bonus_arcanas)):
					handle_win_round()
					current_state = STATE_OUTRO
				else:
					lifes -= 1
					if(lifes == 0):
						handle_lose_game()
					else:
						$CanvasLayer/Overlay.set_lost_level_label(level, lifes)
						reset_round()
						current_state = STATE_WAIT_END_CONFIRM

		STATE_OUTRO:
			$CanvasLayer/Overlay.set_outro_labels(level, lifes)
			current_state = STATE_WAIT_END_CONFIRM

		STATE_WAIT_END_CONFIRM:
			if(Input.is_action_just_pressed("ui_accept")):
				current_state = STATE_INTRO

func handle_lose_game():
		get_tree().change_scene_to_packed(defeat_screen)

func handle_win_round():
	level.increment()
	
	if (level.is_game_won()): 
		get_tree().change_scene_to_packed(victory_screen)
		return

	if(level.get_malus_arcana() is TheSun):
		lifes += 2
	elif(level.get_malus_arcana() is TheWorld):
		var doubled_arcana_index: int = randi_range(0, bonus_arcanas.size() - 1)
		# TODO error when world is the first malus arcana
		bonus_arcanas.append(bonus_arcanas[doubled_arcana_index])
	else:
		bonus_arcanas.append(level.malus_arcana_card)
	reset_round()

func reset_round() -> void:
	# Remove all the instances of the card on the scene
	for card in hand_cards:
		remove_child(card)
		card.queue_free()
	for card in played_cards:
		remove_child(card)
		card.queue_free()

	# Reset round
	hand_cards = []
	played_cards = []
	next_card_id = []
	deck = range(1, 56)
	level.reset()
	
func change_major() -> void:
	$CanvasLayer/Overlay/OptionArcana1.hide()
	$CanvasLayer/Overlay/OptionArcana2.hide()
	
	if ($CanvasLayer/Overlay.major_chosen == 2):
		level.malus_arcana = level.alternate_malus_arcana


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
	played_card.card_played = true

	# Verify of the rule of the major arcana authorize this play, if not do not add any point on the board and sacrifice the card
	if(level.get_malus_arcana().is_card_playable(played_card, played_cards)):
		play_card(played_card)
	else:
		played_cards.append(played_card)
		played_card.position = Vector3(-70, -70, -70)

	replace_hand()
	draw_card(position_z)

func next_malus() -> void:
	if (level.is_last_level()): level.malus_arcana_card = card_factory.fool_arcana_card()
	else:
		level.malus_arcana_card = card_factory.random_major_arcana_card(list_major_arcana)

		if(g.random_major):
			level.alternate_malus_arcana_card = card_factory.random_major_arcana_card(list_major_arcana)


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
	var card: ElementalCard = elemental_card_path.instantiate()

	# Generate a random id for the card and assure that this id was not already taken by a card this round
	card_factory.assign_random_element_to_card(card, deck)
	next_card_id.append(card.id)

	# Write on the card the number and element
	var card_label: Label3D = card.find_child("CardLabel")
	card_label.text = str(card.element.id) + " " + card.element.get_label_text()
	
	# Change the hand in function of the Malus Arcana
	level.get_malus_arcana().malus_effect_on_hand(card)
	add_card_to_hand(card)

func add_card_to_hand(card: ElementalCard) -> void:
	# Keep in memory which card you have to be able to move/delete them later
	hand_cards.append(card)
	var lvl_hand_size: int = g.base_num_card
	var zpos: float = 0.3 * (hand_cards.size() - ceil(lvl_hand_size / 2.0))
	if(get_tree()):
		animate_path.card_movement(get_tree().current_scene, card, 0.1, zpos, $Deck.position, basic_path3D_path)

func play_card(played_card: ElementalCard) -> void:
	played_card.rotate_z(-PI/8)
	played_card.point = played_card.element.get_points(played_cards)
	played_cards.append(played_card)

	level.get_card_points(played_card, played_cards, bonus_arcanas)
	$CanvasLayer/Overlay.write_points(level)

	var zpos: float = -1.45 + (0.25 * played_cards.size())
	played_card.set_position(Vector3(0, 0, zpos))
	
	#Await that all movement off the card stop before making the mesh instance transparent again
	await get_tree().create_timer(0.1).timeout
	_on_area_3d_area_exited(null)
	
func _on_path_terminate(card_id: int):
	animate_path._on_path_terminate(get_tree().current_scene, card_id)

func _on_area_3d_area_entered(_area: Node3D) -> void:
	$Area3DDrag/CollisionShape3D/MeshInstance3D.transparency = 0.5

func _on_area_3d_area_exited(_area: Node3D) -> void:
	$Area3DDrag/CollisionShape3D/MeshInstance3D.transparency = 1

func _on_area_3d_play_area_entered(area: Area3D) -> void:
	if("id" in area):
		_on_card_played(area.id)
