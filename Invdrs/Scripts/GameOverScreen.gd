extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_PlayAgain_pressed():
	get_tree().change_scene("res://Scenes/Main.tscn")


func _on_MainMenu_pressed():
	get_tree().change_scene("res://Scenes/Start.tscn")

func set_score(score):
	$ScoreLabel.text = "Score: " + str(score)
