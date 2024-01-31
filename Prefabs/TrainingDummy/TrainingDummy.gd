extends Node3D


func _ready():
	$HealthComponent.damaged.connect(_on_damaged,0)
	$HealthComponent.died.connect(_on_died,0)


func _on_damaged(_damage: int):
	print("Health: " + str($HealthComponent.health) + "/" + str($HealthComponent.max_health))


func _on_died():
	queue_free()
