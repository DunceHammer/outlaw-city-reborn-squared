extends StaticBody3D


func _ready():
	$InteractableComponent.interacted.connect(_on_interacted, 0)


func _on_interacted():
	queue_free()
