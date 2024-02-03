extends Node2D

const MESSAGES = [
"After a long hiatus...", 
"DunceHammer Return With...", 
"Outlaw City Reborn *Squared*!!!"
]
const GAME_SCENE = "res://Maps/map_development.tscn"
var current_message

func _ready():
	current_message = 0
	$Label.text = MESSAGES[0]


func _on_transition_timer_timeout():
	current_message += 1
	if (current_message >= MESSAGES.size()):
		$TransitionTimer.queue_free()
		$Label.visible = false
		$Menu.visible = true
		return
	$Label.text = MESSAGES[current_message]


func _on_play_pressed():
	get_tree().change_scene_to_file(GAME_SCENE)

func _on_half_quit_pressed():
	set_quit_confirmation_screen_visible(true)

func _on_cancel_quit_pressed():
	set_quit_confirmation_screen_visible(false)

func _on_full_quit_pressed():
	get_tree().quit()

func set_quit_confirmation_screen_visible(is_visible: bool):
	$QuitConfirmation.visible = is_visible
	$Menu.visible = !is_visible
