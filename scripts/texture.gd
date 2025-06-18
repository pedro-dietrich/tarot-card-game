extends Node3D

func _process(delta: float) -> void:
	$WorldEnvironment/CanvasLayer/TextureRect.rotation += delta * 0.1
