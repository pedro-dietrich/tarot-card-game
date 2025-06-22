extends Control

var major_chosen: int = 0

func _ready():
	$TopLabel.text = "UPPER-TEXT"
	$BottomLabel.text = "BOTTOM-TEXT"
	$PointsLabel.text = "POINTS-TEXT"

func set_labels(upper_text: String = "", bottom_text: String = "") -> void:
	$TopLabel.text = upper_text
	$BottomLabel.text = bottom_text

func write_points(level: Level) -> void:
	$PointsLabel.text = str(level.points) + " / " + str(level.target_score)

func write_intro_labels(level: Level):
	set_labels("Level " + str(level.level) + " - Arcana: " + level.malus_arcana.card_name, "Goal of the Level: Achieve " + str(level.target_score) + " points \n" + level.malus_arcana.arcana_penalty_description)
	write_points(level)

func write_choose_labels(level: Level):
	set_labels("Level " + str(level.level) + " - Arcana: " + level.malus_arcana.card_name + "or " + level.alternate_malus_arcana.card_name, "Goal of the Level: Achieve " + str(level.target_score) + " points \n" + level.malus_arcana.arcana_penalty_description + "If you choose " + level.malus_arcana.card_name + "\n" + level.alternate_malus_arcana.arcana_penalty_description + "if you choose " + level.alternate_malus_arcana.card_name)
	write_points(level)
	$OptionArcana1.show()
	$OptionArcana2.show()
	$OptionArcana1.text = level.malus_arcana.card_name
	$OptionArcana2.text = level.alternate_malus_arcana.card_name

func set_lost_level_label(level: Level, lifes: int):
	set_labels("Level " + str(level.level) + " Not completed", "Lifes remaining: " + str(lifes))

func set_outro_labels(level: Level, lifes: int):
	set_labels("Level " + str(level.level), "Lifes: " +str(lifes))
	
func _on_button_2_button_down() -> void:
	major_chosen = 2

func _on_button_button_down() -> void:
	major_chosen = 1
