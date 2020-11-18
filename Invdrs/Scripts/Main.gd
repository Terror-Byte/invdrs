extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var current_row = 0
var left_dir = "left"
var right_dir = "right"
var move_direction = left_dir
var move_down = false
var switch_dir = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.connect("collided_with_edge", self, "_on_Enemy_hit_side")
	print("Enemies connected!")
	$MoveTimerLong.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MoveTimerLong_timeout():
	print("MoveTimerLong")
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
	print("MoveTimerShort")
	move_enemies_in_row(current_row)
	current_row += 1
	if current_row >= 5:
		$MoveTimerLong.start()
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

func _on_Enemy_hit_side():
	#move_down = true
	#if direction == left_dir:
	#	direction = right_dir
	#elif direction == right_dir:
	#	direction = left_dir
	switch_dir = true
