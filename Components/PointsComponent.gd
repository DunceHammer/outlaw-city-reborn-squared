extends Node
class_name PointsComponent


@export var points := 0


func can_afford(cost: int) -> bool:
    return points >= cost


func add_points(amount: int):
    points += amount


func spend_points(cost: int):
    points -= cost


func try_spend_points(cost: int) -> bool:
    if can_afford(cost):
        spend_points(cost)
        return true

    return false

