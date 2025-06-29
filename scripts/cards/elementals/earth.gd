class_name Earth extends Element

var base_card_image_path = "res://assets/card/earth_png/"

var card_image = [
	"e1.png",
	"e2.png",
	"e3.png",
	"e4.png",
	"e5.png",
	"e6.png",
	"e7.png",
	"e8.png",
	"e9.png",
	"e10.png",
	"e11.png",
	"e12.png",
	"e13.png",
	"e14.png"
]

func get_image_path() -> String:
	return base_card_image_path + card_image[id - 1]

func get_points(played_cards: Array[ElementalCard]) -> float:
	return id + 2.0 * played_cards.size() + 2.0

func get_label_text() -> String:
	return "Pentacles"
	
func play_sfx() -> String:
	return "res://assets/sfx/earth_sfx.mp3"
