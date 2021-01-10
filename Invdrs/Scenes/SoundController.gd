extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

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


func death_sound():
	if is_muted == true:
		return
	
	if $DeathSound.playing == false:
		$DeathSound.play()
