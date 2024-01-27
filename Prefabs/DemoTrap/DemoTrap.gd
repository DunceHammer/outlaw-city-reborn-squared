extends Area3D


func _ready():
	connect("body_entered", on_body_entered, 0)
	pass


func on_body_entered(body):
	if body.has_node("HealthComponent"):
		body.get_node("HealthComponent").damage(10)
