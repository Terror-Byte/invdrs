extends Node2D

signal all_enemies_killed

export(NodePath) var sound_controller_path
onready var sound_controller = get_node(sound_controller_path)

# Enemy Stuff
var current_row = 0
var left_dir = "left"
var right_dir = "right"
var move_direction = left_dir
var move_down = false
var switch_dir = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$MoveTimerLong.start()
	$FireTimer.start()
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.connect("killed", self, "_on_Enemy_killed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_switch_dir(dir):
	switch_dir = dir

func _on_MoveTimerLong_timeout():
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


func _on_FireTimer_timeout():
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() == 0:
		return
	var enemy_index = randi() % enemies.size()	
	enemies[enemy_index].fire()
	sound_controller.enemy_fire_sound()
	$FireTimer.start()

# Spawn the special enemy?

func _on_Enemy_killed():
	
	# TODO Send a message to the soundcontroller
	sound_controller.enemy_death_sound()
	
	var enemies = get_tree().get_nodes_in_group("enemies")
	# The reason we're checking if size is 1 is because this method gets called BEFORE the enemy is killed, meaning 
	if enemies.size() == 1:
		# Add in check for if the special enemy exists?
		emit_signal("all_enemies_killed")
		return
	
	# Change "speed" of enemies
	# Initial speed is every 1 sec
	var actual_enemy_count = enemies.size() - 1
	match actual_enemy_count:
		45:
			$MoveTimerLong.wait_time = 0.85
			print("Enemy speed is now: " + str($MoveTimerLong.wait_time))
		35:
			$MoveTimerLong.wait_time = 0.65
			print("Enemy speed is now: " + str($MoveTimerLong.wait_time))
		25:
			$MoveTimerLong.wait_time = 0.45
			print("Enemy speed is now: " + str($MoveTimerLong.wait_time))
		15:
			$MoveTimerLong.wait_time = 0.25
			print("Enemy speed is now: " + str($MoveTimerLong.wait_time))
		5:
			$MoveTimerLong.wait_time = 0.05
			print("Enemy speed is now: " + str($MoveTimerLong.wait_time))
		1:
			$MoveTimerLong.wait_time = 0.01
			print("Enemy speed is now: " + str($MoveTimerLong.wait_time))
		_:
			pass

func game_ended():
	$MoveTimerLong.stop()
	$MoveTimerShort.stop()
	$FireTimer.stop()
