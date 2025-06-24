class_name Wind extends Element

var base_card_image_path = "res://assets/card/air_png/"

var card_image = [
	"a1.png",
	"a2.png",
	"a3.png",
	"a4.png",
	"a5.png",
	"a6.png",
	"a7.png",
	"a8.png",
	"a9.png",
	"a10.png",
	"a11.png",
	"a12.png",
	"a13.png",
	"a14.png"
]

func get_image_path() -> String:
	return base_card_image_path + card_image[id - 1]

func get_points(played_cards: Array[ElementalCard]) -> float:
	var wind_card_count: int = 0
	for card in played_cards:
		if card.element is Wind:
			wind_card_count += 1

	return id + 3.0 * fibonacci(wind_card_count)


func fibonacci(n: int) -> int:
	if(n == 0 or n == 1): return 1
	if(n < 0): return 0
	return fibonacci(n - 1) + fibonacci(n - 2)
	
func get_label_text() -> String:
	return "Wind"
