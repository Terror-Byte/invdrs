extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$PauseSprite.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_pause"):
		get_tree().paused = !get_tree().paused
		# What happens when we pause?? - Player can't move or shoot, enemies can't move or shoot, bullets stop moving
		
		if get_tree().paused == true:
			$PauseSprite.show()
		else:
			$PauseSprite.hide()
