extends Node2D

signal killed

#export (PackedScene) var Bullet
var Bullet = preload("res://Scenes/Bullet.tscn")
var ExplosionAnimation = preload("res://Scenes/ExplosionAnimation.tscn")

export(NodePath) var sound_controller_path
onready var sound_controller = get_node(sound_controller_path)

export var speed = 400
var screen_size
var main

var can_fire = true
var alive = true
var playing = true
var invincible = false
var start_position

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	start_position = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if alive == false or playing == false:
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


func game_ended():
	playing = false


func fire():
	var bullet = Bullet.instance()
	bullet.set_name("PlayerBullet")
	bullet.position = position
	bullet.set_direction("up")
	bullet.z_index = z_index - 1
	get_parent().add_child(bullet)
	can_fire = false
	$FireTimer.start()
	sound_controller.player_fire_sound()


func _on_Player_area_entered(area):
	# Play death animation
	# Remove life
	
	if "EnemyBullet" in area.get_parent().get_name() and invincible == false:
		var explosion = ExplosionAnimation.instance()
		explosion.position = position
		get_parent().add_child(explosion)
		sound_controller.death_sound()
		emit_signal("killed")


func _on_FireTimer_timeout():
	can_fire = true


func set_alive(in_alive):
	alive = in_alive
	
	if alive == true:
		show()
		$Collider/CollisionShape2D.disabled = false
		invincible = true
		$RespawnInvincibilityTimer.start()
		$Sprite/RespawnAnimation.play("Invincible")
	else:
		position = start_position
		hide()
		$Collider/CollisionShape2D.set_deferred("disabled", true)
	

func _on_RespawnInvincibilityTimer_timeout():
	invincible = false
	$Sprite/RespawnAnimation.stop()
