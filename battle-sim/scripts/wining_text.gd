extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func end(team):
	visible = true
	if team == "Blue":
		modulate = Color(0.0, 0.0, 1.0, 1.0)
	else:
		modulate = Color(1.0, 0.0, 0.0, 1.0)
	text = team + " team wins"
	await get_tree().create_timer(1.5).timeout
	get_tree().call_deferred("reload_current_scene")
