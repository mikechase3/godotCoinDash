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
	
	# Error. Not valid in Godot4. Child function use discouraged?
	$ScenePlayer.__help__()  # Funny I can call this & it'll print just fine. Simpler?
	#$ScenePlayer.connect("pickup", self, "_on_player_pickup")	
	#$ScenePlayer.connect("hurt", self, "_on_player_hurt")
	var hurtCall = Callable(self, "_on_player_hurt")
	var pickupCall = Callable(self, "_on_player_pickup")
	
	
	$ScenePlayer.connect("hurt", hurtCall)
	$ScenePlayer.connect("pickup", pickupCall)
	
	#new_game()  # for debugging, to be replaced with a button.

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$ScenePlayer.start()
	$ScenePlayer.show()
	$GameTimer.start()
	spawn_coins()
	
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
	print("Picked up: ", item)
	# Handle picking up my item.
	
func _on_player_hurt() -> void:
	print("Player hurt")
	# Handle player hurt. Reduce time.
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if playing and get_tree().get_nodes_in_group("coins").size() < 1:
		level = level + 1
		time_left += 5
		spawn_coins()
