extends Node2D

signal collided_with_edge
signal killed


var Bullet = preload("res://Scenes/Bullet.tscn")


var left_dir = "left"
var right_dir = "right"
var horizontal_move_distance = 20 # normally like, 10 or something
var vertical_move_distance = 40


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Enemy_area_entered(area):
	var parent_name = area.get_parent().get_name()
	
	if "PlayerBullet" in parent_name:
		emit_signal("killed")
		queue_free()


func fire():
	var bullet = Bullet.instance()
	bullet.set_name("EnemyBullet")
	bullet.position = position
	bullet.set_direction("down")
	bullet.z_index = z_index - 1
	get_parent().add_child(bullet)
	# TODO Play sound

func move(move_direction):
	if move_direction == left_dir:
		position.x -= horizontal_move_distance
	elif move_direction == right_dir:
		position.x += horizontal_move_distance

func move_down():
	position.y += vertical_move_distance
