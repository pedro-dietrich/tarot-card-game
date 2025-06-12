extends Node

@onready var path_follow: PathFollow3D = $PathFollow3D
@export var speed = 0.6

@export var card_id: int = 0

var initial_rotation: Vector3 = Vector3(PI, 0, 0)
var final_rotation = Vector3(0,0,0)

func _ready():
	path_follow.progress = 0

func _process(delta: float) -> void:
	path_follow.progress_ratio += speed * delta
	var card: Card = path_follow.get_child(0)
	if (card):
		card.rotation = initial_rotation * (1 - path_follow.progress_ratio) + final_rotation * path_follow.progress_ratio
	if (path_follow.progress_ratio >= 1.0):
		Events.emit_signal("path_terminate", card_id)
		if (card):
			card.rotation = final_rotation
