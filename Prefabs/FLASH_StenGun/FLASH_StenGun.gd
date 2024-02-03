extends Node3D


var lifetime := 0.1


func _process(delta):
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
		
