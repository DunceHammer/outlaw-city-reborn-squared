extends Node
class_name WeaponStatComponent


@export var idle_animation : String
@export var walk_animation : String
@export var weapon_projectile : PackedScene
@export var weapon_projectile_start : Vector3 = Vector3(0, 0, 0)
@export var weapon_position : Vector3 = Vector3(0, 0, 0)
@export var weapon_rotation : Vector3 = Vector3(0, 0, 0)
@export var attack_cooldown : float = 1.0
