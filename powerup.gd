extends Area2D
var screen_size: Vector2 = Vector2.ZERO

#signal picked_up(item_type)  #

func pickup():
	$CollisionShape2D.set_deferred("disabled", true)
	var tw = create_tween().set_paralel().set_trans(Tween.TRANS_QUAD)
	tw.tween_property(self, "scale", scale * 3, 0.3)
	tw.tween_property(self, "medoulate:a", 0.0, 0.3)
	await tw.finished
	queue_free()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if screen_size == Vector2.ZERO:
		screen_size = get_viewport().get_visible_rect().size
	$Timer.start(randf_range(3, 8))
	$AnimatedSprite2d.frame = 0
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_timer_timeout():
	$AnimatedSprite2d.frame = 0
	$AnimatedSprite2d.play()

func _on_lifetime_timeout() -> void:
	queue_free()

func _on_area_entered(area):
	if area.is_in_group("obstacles"):
		position = Vector2(randi_range(0, screen_size.x), randi_range(0, screen_size.y))
