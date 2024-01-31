extends Node3D


func _ready():
	$HealthComponent.connect("damaged", on_damaged, 0)
	$HealthComponent.connect("died", on_died, 0)


func on_damaged(_damage: int):
	print("Health: " + str($HealthComponent.health) + "/" + str($HealthComponent.max_health))


func on_died():
	queue_free()
