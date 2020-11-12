extends Node2D

var direction
export var Speed = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if direction == "up":
		position.y -= Speed
	elif direction == "down":
		position.y += Speed


func set_direction(dir):
	direction = dir


func _on_Bullet_area_entered(area):
	if (direction == "up") && (area.get_parent().get_name() == "Enemy"):
		# Bullet has been fired by the player and has hit an enemy
		queue_free()
	elif (direction == "down") && (area.get_parent().get_name() == "Player"):
		# Bullet has been fired by an enemy and has hit the player OR a barricade
		queue_free()
