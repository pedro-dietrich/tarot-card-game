extends Control

enum MajorChoice {NONE = 0, FIRST = 1, SECOND = 2}

var major_chosen: MajorChoice = MajorChoice.NONE

func _ready():
	$TopLabel.text = "UPPER-TEXT"
	$BottomLabel.text = "BOTTOM-TEXT"
	$PointsLabel.text = "POINTS-TEXT"

func set_labels(upper_text: String = "", bottom_text: String = "") -> void:
	$TopLabel.text = upper_text
	$BottomLabel.text = bottom_text

func set_goal_level_text(text: String = "") -> void:
	$GameInformation/GoalAtLevel/Text.text = text

func set_rules_element(text: String = "") -> void:
	$GameInformation/RulesLevel/Text.text = text

func write_points(level: Level) -> void:
	$PointsLabel.text = str(level.points) + " / " + str(level.target_score)

func write_intro_labels(level: Level):
	$TopLabel.text = level.get_level_label() + " - " + level.get_malus_arcana().card_name
	set_goal_level_text("Achieve " + str(level.target_score) + " points")
	set_rules_element(level.get_malus_arcana().arcana_penalty_description)
	write_points(level)

func write_choose_labels(level: Level):
	set_labels(level.get_level_label() + " - Arcana: " + level.get_malus_arcana().card_name + "or " + level.get_malus_arcana().card_name, "Goal of the Level: Achieve " + str(level.target_score) + " points \n" + level.get_malus_arcana().arcana_penalty_description + "If you choose " + level.get_malus_arcana().card_name + "\n" + level.alternate_malus_arcana_card.major_arcana.arcana_penalty_description + "if you choose " + level.alternate_malus_arcana_card.card_name)
	write_points(level)
	$OptionArcana1.show()
	$OptionArcana2.show()

func set_lost_level_label(level: Level, lifes: int):
	set_labels(level.get_level_label() + " Not completed", "Lifes remaining: " + str(lifes))

func set_outro_labels(level: Level, lifes: int):
	set_labels(level.get_level_label(), "Lifes: " +str(lifes))
	
func _on_button_2_button_down() -> void:
	major_chosen = MajorChoice.SECOND

func _on_button_button_down() -> void:
	major_chosen = MajorChoice.FIRST
