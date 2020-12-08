extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_score(score):
	$ScoreLabel.text = "Score: " + str(score)

func update_lives(lives):
	match lives:
		3:
			$Life_3.show()
			$Life_2.show()
			$Life_1.show()
		2: 
			$Life_3.show()
			$Life_2.show()
			$Life_1.hide()
		1:
			$Life_3.show()
			$Life_2.hide()
			$Life_1.hide()
		0: 
			$Life_3.hide()
			$Life_2.hide()
			$Life_1.hide()
