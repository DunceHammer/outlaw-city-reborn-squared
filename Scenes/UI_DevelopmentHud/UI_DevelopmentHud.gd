extends Control


@export var player_character : Node3D = null
var points_component = null
var health_component = null


func _ready():
	points_component = player_character.get_node("PointsComponent")
	health_component = player_character.get_node("HealthComponent")
	assert(points_component and health_component, "PlayerCharacter must have PointsComponent and HealthComponent")


func _process(_delta):
	$InteractionLabel.text = "" # Default to no interaction
	var selected_interactable = player_character.selected_interactable

	if selected_interactable:
		var interactable_component = selected_interactable.get_node("InteractableComponent")
		if interactable_component.character_in_range(player_character):
			$InteractionLabel.text = interactable_component.get_text_formatted()

	$HealthLabel.text = "Health: " + str(health_component.health) + " / " + str(health_component.max_health)
	$PointsLabel.text = "Points: " + str(points_component.points)


func _on_enemies_round_increased(current_round):
	$Round.set("theme_override_colors/font_color",Color(150,0,0,1))
	$Round.text = str(current_round)


func _on_enemies_round_cooldown():
	$Round.set("theme_override_colors/font_color",Color(255,255,255,1))
