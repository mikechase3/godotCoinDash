extends Node

# Global Vars
@export var coin_scene: PackedScene
@export var playtime = 30
@export var level = 1
@export var score = 0
@export var time_left = 0
@export var screensize = Vector2.ZERO
@export var playing = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Main scene ready")
	# Configure screen
	screensize = get_viewport().get_visible_rect().size
	$ScenePlayer.screensize = screensize
	$ScenePlayer.hide()
	#$ScenePlayer.connect("pickup", self, "_on_player_pickup")
	#$ScenePlayer.connect("hurt", self, "_on_player_hurt")
	
func _on_player_pickup(item: String) -> void:
	print("Picked up: ", item)
	# Handle picking up my item.
	
func _on_player_hurt() -> void:
	print("Player hurt")
	# Handle player hurt. Reduce time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
