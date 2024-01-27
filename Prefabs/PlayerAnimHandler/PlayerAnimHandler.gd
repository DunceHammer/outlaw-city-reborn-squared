extends Node


@export var library_torso : AnimationLibrary = null
@export var library_legs  : AnimationLibrary = null


var pchar = null
var last_state = null


func _ready():
	# big bug potential here if the character is not the direct parent
	pchar = get_parent()
	
	if library_torso:
		$AnimPlayer_Torso.libraries = { "" : library_torso }
	
	if library_legs:
		$AnimPlayer_Legs.libraries = { "" : library_legs }


func _process(delta):
	if pchar.is_moving:
		$AnimPlayer_Legs.play("Run")
	else:
		$AnimPlayer_Legs.play("Idle")

	if pchar.action_state != last_state:
		last_state = pchar.action_state
		print(pchar.action_state)
		$AnimPlayer_Torso.play(pchar.action_state[3])
		print("playing " + pchar.action_state[3])

