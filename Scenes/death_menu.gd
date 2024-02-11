extends Node2D


const GAME_SCENE = "res://Maps/NightOfTheUndead/MAP_NightOfTheUndead.tscn"
const MENU_SCENE = "res://Scenes/main_menu.tscn"


func _on_play_pressed():
	get_tree().change_scene_to_file(GAME_SCENE)


func _on_menu_pressed():
	get_tree().change_scene_to_file(MENU_SCENE)
