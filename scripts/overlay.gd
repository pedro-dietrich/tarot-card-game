extends Control

func _ready():
	$Background.color = Color(0, 0, 0, 0.7)
	$TopLabel.text = "UPPER-TEXT"
	$BottomLabel.text = "BOTTOM-TEXT"

func set_labels(upper_text: String = "", bottom_text: String = "") -> void:
	$TopLabel.text = upper_text
	$BottomLabel.text = bottom_text

func update_points(points: float, target: float) -> void:
	$PointsLabel.text = str(points) + " / " + str(target)

func visibility_on():
	$Background.color = Color(0, 0, 0, 0.7)

func visibility_off():
	$Background.color = Color(0, 0, 0, 0)
	$TopLabel.text = ""
	$BottomLabel.text = ""
