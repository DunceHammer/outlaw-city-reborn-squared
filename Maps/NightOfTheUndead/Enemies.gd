extends Node

const MAX_ENEMIES = 7
const ENEMY = preload("res://Prefabs/TrainingDummy/TrainingDummy.tscn")

func _ready():
	get_node('../EnemySpawnTimer').start()


func _on_enemy_spawn_timer_timeout():
	if (self.get_child_count() < MAX_ENEMIES):
		var enemy = ENEMY.instantiate()
		enemy.position = Vector3(randi_range(-23, 21), -0.256, randi_range(-15,15))
		self.add_child(enemy)
