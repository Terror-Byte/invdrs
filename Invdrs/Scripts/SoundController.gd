extends Node2D

var is_muted = false

signal muted
signal unmuted

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_mute"):
		if is_muted == true:
			is_muted = false
			emit_signal("unmuted")
			print("Sound is unmuted")
		else:
			is_muted = true
			get_tree().call_group("sound_players", "stop")
			emit_signal("muted")
			print("Sound is muted")


func player_fire_sound():
	if is_muted == true:
		return

	$PlayerFireSound.play()


func player_death_sound():
	if is_muted == true:
		return
		
	$PlayerDeathSound.play()


func enemy_fire_sound():
	if is_muted == true:
		return
		
	$EnemyFireSound.play()


func enemy_death_sound():
	if is_muted == true:
		return
	
	if $EnemyDeathSound.playing == false:
		$EnemyDeathSound.play()
