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


func _process(delta):
	if player_character.is_moving:
		$AnimPlayer_Legs.play("Run")
	else:
		$AnimPlayer_Legs.play("Idle")

