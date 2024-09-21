extends Area2D
var screen_size: Vector2 = Vector2.ZERO

func pickup():
	queue_free()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if screen_size == Vector2.ZERO:
		screen_size = get_viewport().get_visible_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
