extends Node
class_name WeaponComponent


var equipped_weapon = null
@export var weapon_parent : Node3D


var _cooldown = 0.0


func _process(delta: float):
	if _cooldown > 0.0:
		_cooldown -= delta


func can_attack():
	return _cooldown <= 0.0


func get_weapon_stats(weapon: Node):
	var weapon_stats = weapon.get_node("WeaponStatComponent")

	if weapon_stats == null:
		print("WeaponStatComponent not found")
		return null

	return weapon_stats


func get_equipped_weapon_stats():
	if equipped_weapon == null:
		return null

	if not equipped_weapon.has_node("WeaponStatComponent"):
		print("WeaponStatComponent not found")
		return null
	
	var weapon_stats = equipped_weapon.get_node("WeaponStatComponent")
	return weapon_stats


func create_muzzle_flash():
	if equipped_weapon == null:
		return

	var weapon_stats = get_equipped_weapon_stats()
	assert(weapon_stats.muzzle_flash != null, "MuzzleFlash not set")

	var muzzle_flash_instance = weapon_stats.muzzle_flash.instantiate()
	muzzle_flash_instance.position = weapon_stats.muzzle_flash_position
	muzzle_flash_instance.rotation_degrees = weapon_stats.muzzle_flash_rotation
	muzzle_flash_instance.scale = weapon_stats.muzzle_flash_scale
	equipped_weapon.add_child(muzzle_flash_instance)



func attack(pos: Vector3):
	var player = get_parent()
	assert(player.name == "PlayerCharacter")

	if equipped_weapon == null or not can_attack():
		return

	var weapon_stats = get_equipped_weapon_stats()
	assert(weapon_stats.weapon_projectile != null, "Projectile not set")
	
	var projectile_instance = weapon_stats.weapon_projectile.instantiate()
	var projectile_component = projectile_instance.get_node("ProjectileComponent")
	assert(projectile_component != null, "ProjectileComponent not found")

	projectile_instance.position = weapon_stats.weapon_projectile_start
	equipped_weapon.add_child(projectile_instance)

	if not weapon_stats.attach_projectile:
		projectile_instance.reparent(get_node("/root").get_child(0))
	
	projectile_component.set_target(pos)
	projectile_component.fire(player)
	_cooldown = get_equipped_weapon_stats().attack_cooldown
	create_muzzle_flash()
	player.start_fire_timer(weapon_stats.fire_animation_duration)


func equip(weapon: PackedScene):
	var weapon_instance = weapon.instantiate()
	var weapon_stats = get_weapon_stats(weapon_instance)

	if weapon_stats == null:
		print("WeaponStatComponent not found")
		return
		
	if equipped_weapon:
		equipped_weapon.queue_free()

	var desired_scale = weapon_instance.scale / weapon_parent.scale
	weapon_instance.position = weapon_stats.weapon_position
	weapon_instance.rotation_degrees = weapon_stats.weapon_rotation
	weapon_instance.scale = desired_scale
	weapon_parent.add_child(weapon_instance)
	equipped_weapon = weapon_instance
