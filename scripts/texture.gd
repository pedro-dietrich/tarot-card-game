extends Node3D

func _process(delta: float) -> void:
	$WorldEnvironment/TextureRect.rotation += delta * 0.1
