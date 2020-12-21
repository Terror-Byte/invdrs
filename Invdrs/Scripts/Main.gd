extends Node2D

signal game_over

# Player Stuff
var score = 0
var lives = 3

var enemies_at_left_edge = 0
var enemies_at_right_edge = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		enemy.connect("killed", self, "_on_Enemy_killed")
		
	$Player.connect("killed", self, "_on_Player_killed")
	$Enemies.connect("all_enemies_killed", self, "_on_Enemies_all_enemies_killed")
	$HUD.update_score(score)
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_MapEdgeLeft_area_entered(area):
	if not ("Enemy" in area.get_parent().get_name()):
		return
	
	enemies_at_left_edge += 1
	if enemies_at_left_edge == 1:
		#switch_dir = true
		$Enemies.set_switch_dir(true)

func _on_MapEdgeLeft_area_exited(area):
	if not ("Enemy" in area.get_parent().get_name()):
		return
		
	if enemies_at_left_edge > 0:
		enemies_at_left_edge -= 1


func _on_MapEdgeRight_area_entered(area):
	if not ("Enemy" in area.get_parent().get_name()):
		return
		
	enemies_at_right_edge += 1
	if enemies_at_right_edge == 1:
		$Enemies.set_switch_dir(true)


func _on_MapEdgeRight_area_exited(area):
	if not ("Enemy" in area.get_parent().get_name()):
		return
	if enemies_at_right_edge > 0:
		enemies_at_right_edge -= 1


func _on_Enemy_killed():
	score += 100
	$HUD.update_score(score)


func _on_Player_killed():
	lives -= 1
	$HUD.update_lives(lives)
	$Player.set_alive(false)
	if lives <= 0:
		print("You lose!")
		# Stop everything and show death screen!
		get_tree().change_scene("res://Scenes/Start.tscn")
	else:
		$RespawnTimer.start()


func _on_RespawnTimer_timeout():
	$Player.set_alive(true)
	#$Player.show()


func _on_Enemies_all_enemies_killed():
	# What happens when the player "wins"?
	print("You win!")


func _on_MapBottom_area_entered(area):
	print("Game over!!")
	#emit_signal("game_over") # Things will react to this - player will stop moving, enemies will stop moving, game over screen will appears
	
	# TODO:
	#  Show end screen (GAME OVER text, player score, try again button (which will reload the scene "get_tree().change_scene("res://Scenes/Main.tscn")").
	#  PLAYER: Stop moving
	#  
	
	# $Player.game_over() <-- deletes all player bullets??
	# $Enemies.game_over() <-- deletes all enemy bullets??
	# delete all bullets??
	pass # Replace with function body.
