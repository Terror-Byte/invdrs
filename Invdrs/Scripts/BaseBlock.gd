extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var Health = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_BaseBlock_area_entered(area):
	var parent_name = area.get_parent().get_name()
	if "EnemyBullet" in parent_name:
		#queue_free()
		Health -= 1
		if Health <= 0:
			queue_free()
