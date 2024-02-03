extends Node
class_name HealthComponent


@export var can_die = true
@export var can_be_damaged = true
@export var health = 100
@export var max_health = 100


signal died()
signal damaged(damage: int)


func damage(damage_amount: int):
	if can_be_damaged and health > 0:
		health -= damage_amount
		damaged.emit(damage_amount)
		if health <= 0:
			health = 0
			if can_die:
				died.emit()

	if health < 0:
		health = 0


func _ready():
	print("HealthComponent ready")

