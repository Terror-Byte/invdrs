extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Player Stuff
var score = 0
var lives = 3

# Enemy Stuff
var current_row = 0
var left_dir = "left"
var right_dir = "right"
var move_direction = left_dir
var move_down = false
var switch_dir = false

var enemies_at_left_edge = 0
var enemies_at_right_edge = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.connect("killed", self, "_on_Enemy_killed")
	$Player.connect("killed", self, "_on_Player_killed")
	#print("Enemies connected!")
	$MoveTimerLong.start()
	$FireTimer.start()
	$HUD.update_score(score)
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MoveTimerLong_timeout():
	#print("MoveTimerLong")
	if switch_dir == true:
		switch_dir = false
		move_down = true
		if move_direction == left_dir:
			move_direction = right_dir
		elif move_direction == right_dir:
			move_direction = left_dir
	
	current_row = 0
	move_enemies_in_row(current_row)
	current_row += 1
	$MoveTimerShort.start()

func _on_MoveTimerShort_timeout():
	#print("MoveTimerShort")
	move_enemies_in_row(current_row)
	current_row += 1
	if current_row >= 5:
		$MoveTimerLong.start()
		if move_down == true:
			move_down = false
	else:
		$MoveTimerShort.start()


func move_enemies_in_row(row):
	var name = "row_" + str(row)
	var enemies = get_tree().get_nodes_in_group(name)
	if enemies.size() > 0:
		for enemy in enemies:
			if move_down == true:
				enemy.move_down()
			else:
				enemy.move(move_direction)


#func _on_Enemy_hit_side():
#	#move_down = true
#	#if direction == left_dir:
	#	direction = right_dir
	#elif direction == right_dir:
	#	direction = left_dir
#	switch_dir = true


func _on_MapEdgeLeft_area_entered(area):
	if not ("Enemy" in area.get_parent().get_name()):
		return
	
	enemies_at_left_edge += 1
	if enemies_at_left_edge == 1:
		switch_dir = true

func _on_MapEdgeLeft_area_exited(area):
	if not ("Enemy" in area.get_parent().get_name()):
		return
		
	if enemies_at_left_edge > 0:
		enemies_at_left_edge -= 1


func _on_MapEdgeRight_area_entered(area):
	if not ("Enemy" in area.get_parent().get_name()):
		return
		
	enemies_at_right_edge += 1
	if enemies_at_right_edge == 1:
		switch_dir = true


func _on_MapEdgeRight_area_exited(area):
	if not ("Enemy" in area.get_parent().get_name()):
		return
		
	if enemies_at_right_edge > 0:
		enemies_at_right_edge -= 1


func _on_FireTimer_timeout():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var enemy_index = randi() % enemies.size()
	
	if enemy_index == 0:
		return
	
	enemies[enemy_index].fire()
	$FireTimer.start()

func _on_Enemy_killed():
	score += 100
	$HUD.update_score(score)
	$EnemyDeathSound.play()

func _on_Player_killed():
	lives -= 1
	$HUD.update_lives(lives)
	$Player.set_alive(false)
	if lives <= 0:
		return # Game over!
	else:
		$RespawnTimer.start()

func _on_RespawnTimer_timeout():
	$Player.set_alive(true)
	#$Player.show()
