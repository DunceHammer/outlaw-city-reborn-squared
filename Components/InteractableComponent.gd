extends Node
class_name InteractableComponent


@export var text = "Example format $PRICE"
@export var price = 100
@export var min_interact_distance = 5.0


signal interacted()


func get_text_formatted() -> String:
	return text.replace("$PRICE", str(price))


func character_in_range(character: Node3D) -> bool:
	var dist = character.position.distance_to(get_parent().global_transform.origin)
	return dist < min_interact_distance


func try_interact(character: Node3D) -> bool:
	assert(character.has_node("PointsComponent"), "Character must have PointsComponent")
	if character_in_range(character) and character.get_node("PointsComponent").try_spend_points(price):
		interacted.emit()
		return true
	return false
