extends Area3D


@export var weapon : PackedScene


func _ready():
	connect("body_entered", on_body_entered, 0)


func on_body_entered(body):
	if body.has_node("WeaponComponent"):
		body.get_node("WeaponComponent").equip(weapon)
		queue_free()
