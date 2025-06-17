extends Control

func _ready():
	$TopLabel.text = "UPPER-TEXT"
	$BottomLabel.text = "BOTTOM-TEXT"
	$PointsLabel.text = "POINTS-TEXT"

func set_labels(upper_text: String = "", bottom_text: String = "") -> void:
	$TopLabel.text = upper_text
	$BottomLabel.text = bottom_text

func write_points(level: Level) -> void:
	$PointsLabel.text = str(level.ponts) + " / " + str(level.target_score)

func write_intro_labels(level: Level):
	set_labels("Level " + str(level.level) + " - Arcana: " + level.malus_arcana.card_name, "Goal of the Level: Achieve " + str(level.target_score) + " points \n" + level.malus_arcana.arcana_penalty_description)
	write_points(level)

func set_lost_level_label(level: Level, lifes: int):
	set_labels("Level " + str(level.level) + " Not completed", "Lifes remaining: " + str(lifes))

func set_outro_labels(level: Level, lifes: int):
	set_labels("Level " + str(level.level), "Lifes: " +str(lifes))
