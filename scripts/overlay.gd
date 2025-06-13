extends Control

func _ready():
	$TopLabel.text = "UPPER-TEXT"
	$PointsLabel.text = "POINTS-TEXT"
	$BottomLabel.text = "BOTTOM-TEXT"

func set_labels(upper_text: String = "", bottom_text: String = "") -> void:
	$TopLabel.text = upper_text
	$BottomLabel.text = bottom_text

func update_points(points: float, target: float) -> void:
	$PointsLabel.text = str(points) + " / " + str(target)

func remove_labels():
	$TopLabel.text = ""
	$BottomLabel.text = ""
	$PointsLabel.text = ""
