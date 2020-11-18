extends Node2D

signal collided_with_edge

#export (PackedScene) var Bullet
var Bullet = preload("res://Scenes/Bullet.tscn")

var can_fire = false
var left_dir = "left"
var right_dir = "right"
var direction = left_dir
# move_down is true if the enemy has recently hit the edge and must move down
var move_down = false
var horizontal_move_distance = 20 # normally like, 10 or something
var vertical_move_distance = 40

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#$MoveTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if (can_fire == true):
	#	if (randi() % 10 + 1) == 5:
	#		spawn_bullet()
	#		can_fire = false
	#		$FireTimer.start()
	
	if (can_fire == true):
		spawn_bullet()
		can_fire = false
		$FireTimer.start()


func _on_Enemy_body_entered(body):
	print(body + " hit enemy!")
	pass # Replace with function body.


func _on_Enemy_area_entered(area):
	#print(area.get_parent().get_name())
	var parent_name = area.get_parent().get_name()
	#var collider_name = area.get_name()
	#print("Enemy has collided with: " + collider_name)
	print("Enemy has collided with: " + parent_name)
	
	if "PlayerBullet" in parent_name:
		queue_free()
	#elif collider_name == "MapEdgeLeft" or collider_name == "MapEdgeRight":
	#	emit_signal("collided_with_edge")
	#	#get_tree().call_group("enemies", "collided_with_edge")
	#elif collider_name == "MapBottom":
	#	# Trigger end of game
		# TODO Do we do this on the player, or on some game controller??
#		print("Enemy has hit the bottom!")


func spawn_bullet():
	var bullet = Bullet.instance()
	bullet.set_name("EnemyBullet")
	bullet.position = position
	bullet.set_direction("down")
	bullet.z_index = z_index - 1
	get_parent().add_child(bullet)
	#print("Bullet fired by enemy")
	# TODO Play sound


func _on_FireTimer_timeout():
	can_fire = true


#func _on_Enemy_collided_with_edge():
	#print("Enemy collided with edge!")
	# TODO:
	# Move down a row (move like, the distancce equivalent to the length of an enemy
	#position.y += vertical_move_distance
	# Flip movement direction
	#move_down = true
	#if direction == left_dir:
	#	direction = right_dir
	#elif direction == right_dir:
	#	direction = left_dir
#	pass

#func collided_with_edge():
#	move_down = true
#	if direction == left_dir:
#		direction = right_dir
#	elif direction == right_dir:
#		direction = left_dir

func move(move_direction):
	#if move_down == true:
	#	position.y += vertical_move_distance
	#	move_down = false
	#else:
	#	if move_direction == left_dir:
	#		position.x -= horizontal_move_distance
	#	elif move_direction == right_dir:
	#		position.x += horizontal_move_distance
	if move_direction == left_dir:
		position.x -= horizontal_move_distance
	elif move_direction == right_dir:
		position.x += horizontal_move_distance

func move_down():
	position.y += vertical_move_distance

# OBSOLETE
func _on_MoveTimer_timeout():
	if move_down == true:
		position.y += vertical_move_distance
		move_down = false
	else:
		if direction == left_dir:
			position.x -= horizontal_move_distance
		elif direction == right_dir:
			position.x += horizontal_move_distance

	$MoveTimer.start()
