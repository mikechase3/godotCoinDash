extends Node

# Global Vars
@export var coin_scene: PackedScene  # point to .tscn in the inspector?
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
			

	
func _on_player_pickup(item: String) -> void:
	score += 1
	print("Picked up: ", item)
	# Handle picking up my item.
	
func _on_player_hurt() -> void:
	game_over()
	print("Player hurt")
	# Handle player hurt. Reduce time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if playing and get_tree().get_nodes_in_group("coins").size() < 1:
		level = level + 1
		time_left += 5
		spawn_coins()

func _on_game_timer_timeout():
	time_left -= 1
	$scene_hud.update_timer(time_left)
	if time_left < 0:
		game_over()  # end if the game's time is up.

func game_over():
	playing = false
	$GameTimer.stop()
	get_tree().call_group("coins", "queue_free")
	$scene_hud.show_game_over()
	$ScenePlayer.die()

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
	
	# Spawn coins & update the HUD
	spawn_coins()
	$scene_hud.update_score(score)
	$scene_hud.update_timer(time_left)


#func _on_scene_hud_start_game() -> void:
	#print("DEBUG at scene_main._on_hud_start_game(): Received the start_game signal on scene_main.gd")
	#new_game()  # starts a new game when HUD sends the start_game signal.
