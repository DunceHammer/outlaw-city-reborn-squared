extends Node


@export var library_torso : AnimationLibrary = null
@export var library_legs  : AnimationLibrary = null


var player_character = null


func _ready():
	# big bug potential here if the character is not the direct parent
	player_character = get_parent()
	
	if library_torso:
		$AnimPlayer_Torso.libraries = { "" : library_torso }
	
	if library_legs:
		$AnimPlayer_Legs.libraries = { "" : library_legs }


func _process(_delta):
	var weapon = player_character.get_node("WeaponComponent").equipped_weapon
	var weapon_stats = weapon.get_node("WeaponStatComponent") if weapon else null
	var block_torso = false

	if weapon_stats and player_character.is_firing:
		$AnimPlayer_Torso.play(weapon_stats.fire_animation)
		block_torso = true

	if player_character.is_moving:
		if not block_torso:
			$AnimPlayer_Torso.play(weapon_stats.walk_animation if weapon_stats else "Walk")
		$AnimPlayer_Legs.play("Walk")
	else:
		if not block_torso:
			$AnimPlayer_Torso.play(weapon_stats.idle_animation if weapon_stats else "Default")
		$AnimPlayer_Legs.play("Default")
