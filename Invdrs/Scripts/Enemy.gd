extends Node2D

export (PackedScene) var Bullet

var can_fire = true

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


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
	if area.get_parent().get_name() == "PlayerBullet":
		queue_free()


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
