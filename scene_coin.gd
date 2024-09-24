extends Area2D
var screen_size: Vector2 = Vector2.ZERO

signal picked_up(item_type)

func pickup():
	$CollisionShape2D.set_deferred("disabled", true)
	var tw = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tw.tween_property(self, "scale", scale * 3, 0.3)
	tw.tween_property(self, "medoulate:a", 0.0, 0.3)
	await tw.finished
	queue_free()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if screen_size == Vector2.ZERO:
		screen_size = get_viewport().get_visible_rect().size
	$Timer.start(randf_range(3, 8))


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("obstacles"):
		position = Vector2(randi_range(0, screen_size.x), randi_range(0, screen_size.y))



func _on_timer_timeout() -> void:
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play()
