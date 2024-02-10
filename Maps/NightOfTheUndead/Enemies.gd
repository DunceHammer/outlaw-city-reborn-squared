extends Node


const ENEMY = preload("res://Prefabs/TrainingDummy/TrainingDummy.tscn")

signal round_increased
signal round_cooldown


var current_round = 1
var max_enemies = 1
var enemies_spawned = 0
var enemy_spawn_timer
var round_cooldown_timer


func _ready():
	enemy_spawn_timer = get_node('../EnemySpawnTimer')
	round_cooldown_timer = get_node('../RoundCooldownTimer')
	enemy_spawn_timer.start()


func start_new_round():
	round_cooldown_timer.stop()
	current_round += 1
	enemies_spawned = 0
	max_enemies += 1


func _on_enemy_spawn_timer_timeout():
	if (enemies_spawned < max_enemies):
		var enemy = ENEMY.instantiate()
		enemy.position = Vector3(randi_range(-23, 21), -0.256, randi_range(-15,15))
		self.add_child(enemy)
		enemies_spawned += 1


func _on_child_exiting_tree(node):
	if (self.get_child_count() == 1 && enemies_spawned == max_enemies):
		round_cooldown.emit()
		round_cooldown_timer.start()


func _on_round_cooldown_timer_timeout():
	start_new_round()
	round_increased.emit(current_round)
