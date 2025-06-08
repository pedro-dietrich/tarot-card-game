extends Node

@onready var path_follow: PathFollow3D = $PathFollow3D
@export var speed = 0.5

@export var card_id: int = 0

func _ready():
	path_follow.progress = 0

func _process(delta: float) -> void:
	path_follow.progress += speed * delta
	if (path_follow.progress_ratio == 1):
		Events.emit_signal("path_terminate", card_id)
		pass
