extends CanvasLayer

export(NodePath) var sound_controller_path
onready var sound_controller = get_node(sound_controller_path)


# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioSprites/AudioOn.show()
	$AudioSprites/AudioOff.hide()
	
	sound_controller.connect("muted", self, "_on_SoundController_muted")
	sound_controller.connect("unmuted", self, "_on_SoundController_unmuted")

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

func _on_SoundController_muted():
	$AudioSprites/AudioOn.hide()
	$AudioSprites/AudioOff.show()
	
func _on_SoundController_unmuted():
	$AudioSprites/AudioOn.show()
	$AudioSprites/AudioOff.hide()
