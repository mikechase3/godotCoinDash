extends Area2D

signal pickup(item: String)
signal hurt

# Initialization and Variables
@export var speed: int = 350
var velocity: Vector2 = Vector2.ZERO
var screensize: Vector2 = Vector2(960, 1440)


func _process(delta: float) -> void:
	# Handle user's input.
	var iDontLikeThisSolution: int = 1  # Safe to remove now! 
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += velocity * speed * delta  # Position is a Vector2
	position.x = clamp(position.x, 0, screensize.x * iDontLikeThisSolution)
	position.y = clamp(position.y, 0, screensize.y * iDontLikeThisSolution)
	
	# Flip the sprite when moving & 
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"  # .animation = <str>
	else:
		$AnimatedSprite2D.animation = "idle"
		
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0

func start() -> void:
	set_process(true)
	position = screensize / 2
	$AnimatedSprite2D.animation = "idle"
	
func die() -> void:
	$AnimatedSprite2D.animation = "hurt2"
	set_process(false)
	

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coin")
	if area.is_in_group("powerups"):
		area.pickup()
		pickup.emit("powerup")
	if area.is_in_group("obstacles"):
		hurt.emit()
		die()
		
func __help__() -> String:
	print("Running from scene_player... returning a string")
	return("You called help from ScenePlayer")



		
# For GameManager or HUD Script
#func _ready() -> void:
	#pass
	##$Player.connect("pickup", self, "_on_player_pickup")
	##$Player.connect("hurt", self, "_on_player_hurt")
	#
#func _on_pickup(item: String) -> void:
	#print("Picked up:", item)
	## Handle the item pickup (update HUD, score, etc.)
#
#func _on_hurt() -> void:
	#print("Player hurt")
	## Handle player being hurt (reduce health, play sound, etc.)
