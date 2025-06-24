class_name Water extends Element

var base_card_image_path = "res://assets/card/water_png/"

var card_image = [
	"w1.png",
	"w2.png",
	"w3.png",
	"w4.png",
	"w5.png",
	"w6.png",
	"w7.png",
	"w8.png",
	"w9.png",
	"w10.png",
	"w11.png",
	"w12.png",
	"w13.png",
	"w14.png"
]

func get_image_path() -> String:
	return base_card_image_path + card_image[id - 1]
	
func get_points(played_cards: Array[ElementalCard]) -> float:
	if played_cards.size() == 0:
		return id
	return id + 0.5 * played_cards.back().point

func get_label_text() -> String:
	return "Water"
