class_name Fire extends Element

var base_card_image_path = "res://assets/card/fire_png/"

var card_image = [
	"f1.png",
	"f2.png",
	"f3.png",
	"f4.png",
	"f5.png",
	"f6.png",
	"f7.png",
	"f8.png",
	"f9.png",
	"f10.png",
	"f11.png",
	"f12.png",
	"f13.png",
	"f14.png"
]

func get_image_path() -> String:
	return base_card_image_path + card_image[id - 1]

func get_points(_played_cards: Array[ElementalCard]) -> float:
	return 5.0 + id

func get_label_text() -> String:
	return "Wands"
	

func play_music() -> String:
	return "res://assets/elements/musics/Fire.mp3"
