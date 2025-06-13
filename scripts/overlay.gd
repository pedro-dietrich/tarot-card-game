extends Control

func _ready():
	$TopLabel.text = "UPPER-TEXT"
	$PointsLabel.text = "POINTS-TEXT"
	$BottomLabel.text = "BOTTOM-TEXT"

func set_labels(upper_text: String = "", bottom_text: String = "") -> void:
	$TopLabel.text = upper_text
	$BottomLabel.text = bottom_text

func write_points(points: String, target: String) -> void:
	$PointsLabel.text = points + " / " + target

func write_intro_labels(level: String, card_name: String, target_score: String, arcana_penalty_description: String):
	set_labels("Level " + level + " - Arcana: " + card_name, "Goal of the Level: Achieve " + target_score + " points \n" + arcana_penalty_description)

func remove_labels():
	$TopLabel.text = ""
	$BottomLabel.text = ""
	$PointsLabel.text = ""
