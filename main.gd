extends Node

@export var mob_scene: PackedScene #mob object
var score

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_gameOver()
	
func new_game():
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Player.reStart($StartPosition.position)
	$StartTimer.start()


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	var rotation_direction = mob_spawn_location.rotation + PI / 2
	rotation_direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = rotation_direction
	mob.position = mob_spawn_location.position
	
	var mob_movement_vector = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = mob_movement_vector.rotated(rotation_direction)
	
	add_child(mob)
