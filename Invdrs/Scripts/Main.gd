extends Node2D

signal game_over

# Player Stuff
var score = 0
var lives = 3

var enemies_at_left_edge = 0
var enemies_at_right_edge = 0

const GameOverScreenScene = preload("res://Scenes/GameOverScreen.tscn")
const WinScreenScene = preload("res://Scenes/WinScreen.tscn")

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
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://Scenes/Start.tscn")
		
	if Input.is_action_just_pressed("ui_pause"):
		#get_tree().paused = !get_tree().paused
		# What happens when we pause?? - Player can't move or shoot, enemies can't move or shoot, bullets stop moving
		pass

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
		#get_tree().change_scene("res://Scenes/Start.tscn")
		game_over()
	else:
		$RespawnTimer.start()


func _on_RespawnTimer_timeout():
	$Player.set_alive(true)


func _on_Enemies_all_enemies_killed():
	game_win()


func _on_MapBottom_area_entered(area):
	if "Enemy" in area.get_parent().get_name() and not "Bullet" in area.get_parent().get_name():
		print("Game over!!")
		game_over()
	
	#emit_signal("game_over") # Things will react to this - player will stop moving, enemies will stop moving, game over screen will appears


func game_over():
	# TODO:
	#  Show end screen (GAME OVER text, player score, try again button (which will reload the scene "get_tree().change_scene("res://Scenes/Main.tscn")").
	#  PLAYER: Stop moving
	#  
	# $Player.game_over() <-- deletes all player bullets??
	# $Enemies.game_over() <-- deletes all enemy bullets??
	# delete all bullets??
	
	$Player.game_ended()
	$Enemies.game_ended()
	var gameOverScreen = GameOverScreenScene.instance()
	self.add_child(gameOverScreen)
	gameOverScreen.set_score(score)
	get_tree().call_group("bullet", "queue_free")


func game_win():
	# What happens when the player "wins"?
	# TODO:
	#  Stop player from moving
	#  Delete all player bullets
	#  Show win screen
	
	$Player.game_ended()
	$Enemies.game_ended()
	var winScreen = WinScreenScene.instance()
	self.add_child(winScreen)
	winScreen.set_score(score)
	get_tree().call_group("bullet", "queue_free")
