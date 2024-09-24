extends Node

# Global Vars
@export var coin_scene: PackedScene  # point to .tscn in the inspector?
@export var powerup_scene: PackedScene
@export var obstacle_scene: PackedScene
@export var playtime = 30

@export var level = 1
@export var score = 0
@export var time_left = 0
@export var screensize = Vector2.ZERO
@export var playing = false




# Called when the node enters the scene tree for the first time.
func _ready() -> void:  # called on every node when it's added (instantiated?)
	print("Main scene ready")
	
	# Configure screen; book p.35 contents.
	screensize = get_viewport().get_visible_rect().size
	$ScenePlayer.screensize = screensize
	$ScenePlayer.hide()
	
# 	# Connect player signals; note v4x differs from v3 in Godot signal connecting w/ callables.
	var hurtCall = Callable(self, "_on_player_hurt")
	var pickupCall = Callable(self, "_on_player_pickup")
	$ScenePlayer.connect("hurt", hurtCall)
	$ScenePlayer.connect("pickup", pickupCall)
	
	# Connecting the GameTimer signal - TODO: only requires two args???
	#$GameTimer.timeout.connect("_on_hud_start_game", Callable(self, "_on_game_timer_timeout"))
	var call_start_game_from_hud = Callable(self, "_on_game_timer_timeout")
	$GameTimer.timeout.connect(call_start_game_from_hud)
	
	# Connect the Hub
	#print("Is scene_hub valid?: If null, that's bad. ")
	#print($scene_hud)
	$scene_hud.start_game.connect(Callable(self, "_on_hud_start_game"))
	#var temp_callable = Callable(self, "start_game")
	#if temp_callable == true:
		#print("scene_main.gd DEBUG: Received the start_game signal on scene_main.gd probably!")
	#$scene_hud.start_game.connect("_on_hud_start_game", temp_callable)
	#new_game()  # for debugging, to be replaced with a button.


	
func spawn_coins():
	var numCoinsToSpawn: int = level + 4
	for i in numCoinsToSpawn:
		var c = coin_scene.instantiate()  # a "packed scene"; declared at top
		add_child(c)  # adds child to scene tree at bottom I hope.
		c.screen_size = screensize
		var rx = randi_range(0, screensize.x)
		var ry = randi_range(0, screensize.y)
		c.position = Vector2(rx, ry)
	$LevelSound.play()
			
			
func spawn_obstacles():
	"""
	Spawns moon rocks. LLM-aided function hency why it doesn't work.
	"""
	var numObstaclesToSpawn: int = level + 3
	var player_position = $ScenePlayer.position

	for j in numObstaclesToSpawn:
		var o = obstacle_scene.instantiate()
		add_child(o)
		#o.screen_size = get_viewport().get_visible_rect().size  # TODO: don't use this expensive func in a loop.

		# Generate random position for obstacle
		var rx = randi_range(0, screensize.x)
		var ry = randi_range(0, screensize.y)

		# Ensure obstacle doesn't overlap the player's position (±10 pixels)
		while abs(rx - player_position.x) <= 10 and abs(ry - player_position.y) <= 10:
			rx = randi_range(0, screensize.x)
			ry = randi_range(0, screensize.y)

		# Set the obstacle's position
		o.position = Vector2(rx, ry)


	
func _on_player_pickup(item: String) -> void:  # Unused; my attempt.
	print("DEBUG scene_main._on_player_pickup")
	match item:
		"coin":
			$CoinSound.play()
			score += 1
			$scene_hud.update_score(score)
		"powerup":
			$PowerupSound.play()
			time_left += 5
			$scene_hud.update_timer(time_left)
		"obstacle":  # cactus -> now moon rocks.
			_on_player_hurt()  # TODO: Remove, Probably shouldn't call this manually.
	# Handle picking up my item.
	
	
	
func _on_player_hurt() -> void:
	"""
	Handle player hurt. Reduce time.
	"""
	
	game_over()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		$LevelUp.play()
		level = level + 1
		time_left += 5
		spawn_coins()
		spawn_obstacles()
		if (level % 5 == 0):
			$MegaSkills.play()
		$PowerupTimer.wait_time = randf_range(5, 10)
		$PowerupTimer.start()

func _on_game_timer_timeout():
	time_left -= 1
	$scene_hud.update_timer(time_left)
	if time_left <= 0:
		game_over()  # end if the game's time is up.

func game_over():
	playing = false
	$GameTimer.stop()
	get_tree().call_group("coins", "queue_free")
	$scene_hud.show_game_over()
	$ScenePlayer.die()
	$EndSound.play()
	if (level < 5):
		$YouSuck.play()

func _on_hud_start_game():  # TODO: Delete. never gets called?!!
	print("DEBUG at scene_main._on_hud_start_game(): Received the start_game signal on scene_main.gd")
	new_game()  # starts a new game when HUD sends the start_game signal.
	
func new_game() -> void:
	playing = true
	level = 1
	score = 0
	time_left = playtime
	
	# Start the player/timer:
	$ScenePlayer.start()
	$ScenePlayer.show()
	$GameTimer.start()
	
	# Spawn coins, obstalces & update the HUD
	spawn_coins()
	spawn_obstacles()
	$scene_hud.update_score(score)
	$scene_hud.update_timer(time_left)



#func _on_scene_hud_start_game() -> void:
	#print("DEBUG at scene_main._on_hud_start_game(): Received the start_game signal on scene_main.gd")
	#new_game()  # starts a new game when HUD sends the start_game signal.


func _on_powerup_timer_timeout():
	var p = powerup_scene.instantiate()
	add_child(p)
	#p.screensize = screensize
	p.position = Vector2(randi_range(0, 960), randi_range(0, 1440))


func _on_scene_player_pickup(item: String) -> void:  # What actually runs; not 
	print("DEBUG scene_main._on_player_pickup")
	match item:
		"coin":
			$CoinSound.play()
			score += 1
			$scene_hud.update_score(score)
		"powerup":
			$PowerupSound.play()
			time_left += 5
			$scene_hud.update_timer(time_left)
		"obstacle":
			_on_player_hurt()
	# Handle picking up my item.


func _on_scene_player_hurt() -> void:
	game_over()


func _on_scene_obstacle_area_entered(area: Area2D) -> void:
	print("DEBUG: Collided with rock - game over")
	_on_player_hurt()


func _on_scene_obstacle_hit_obstacle() -> void:
	print("DEBUG: Collided with rock - game over")
	_on_player_hurt()
