extends Area2D
@export var screen_size: Vector2 = Vector2.ZERO

func pickup():
	queue_free()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = Vector2.ZERO  # try it here? 
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
