extends Node2D

signal hit

#export (PackedScene) var Bullet
var Bullet = preload("res://Scenes/Bullet.tscn")

export var speed = 400
var screen_size
var main

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	
	if Input.is_action_just_pressed("ui_accept"):
		spawn_bullet()
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		
	if velocity.length() > 0:
		velocity = velocity * speed
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


func spawn_bullet():
	var bullet = Bullet.instance()
	bullet.set_name("PlayerBullet")
	bullet.position = position
	bullet.set_direction("up")
	bullet.z_index = z_index - 1
	get_parent().add_child(bullet)
	# TODO Play sound


func _on_Player_area_entered(area):
	# Play death animation
	# Remove life
	# Emit the hit signal, if we need it??
	if (area.get_parent().get_name() == "EnemyBullet"):
		queue_free()
