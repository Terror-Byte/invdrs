extends Node2D

signal killed

#export (PackedScene) var Bullet
var Bullet = preload("res://Scenes/Bullet.tscn")

export var speed = 400
var screen_size
var main

var can_fire = true
var alive = true
var start_position

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	start_position = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if alive == false:
		return
	
	var velocity = Vector2()
	
	if Input.is_action_just_pressed("ui_accept") and can_fire == true:
		fire()
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		
	if velocity.length() > 0:
		velocity = velocity * speed
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


func fire():
	var bullet = Bullet.instance()
	bullet.set_name("PlayerBullet")
	bullet.position = position
	bullet.set_direction("up")
	bullet.z_index = z_index - 1
	get_parent().add_child(bullet)
	can_fire = false
	$FireTimer.start()
	$FireSound.play()


func _on_Player_area_entered(area):
	# Play death animation
	# Remove life
	
	if "EnemyBullet" in area.get_parent().get_name():
		emit_signal("killed")
		$DeathSound.play()


func _on_FireTimer_timeout():
	can_fire = true


func set_alive(in_alive):
	alive = in_alive
	
	if alive == true:
		show()
		$Collider/CollisionShape2D.disabled = false
	else:
		position = start_position
		hide()
		$Collider/CollisionShape2D.set_deferred("disabled", true)
