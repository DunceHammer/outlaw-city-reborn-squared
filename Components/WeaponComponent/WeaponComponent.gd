extends Node
class_name WeaponComponent


var equipped_weapon = null
@export var weapon_parent : Node3D


func _ready():
	pass


func equip(weapon: PackedScene):
	var weapon_instance = weapon.instantiate()
	if not weapon_instance.has_node("WeaponStatComponent"):
		print("WeaponStatComponent not found")
		return
	
	var weapon_stats = weapon_instance.get_node("WeaponStatComponent")
	var desired_scale = weapon_instance.scale / weapon_parent.scale
	weapon_instance.position = weapon_stats.weapon_position
	weapon_instance.rotation_degrees = weapon_stats.weapon_rotation
	weapon_instance.scale = desired_scale
	weapon_parent.add_child(weapon_instance)
	equipped_weapon = weapon_instance
