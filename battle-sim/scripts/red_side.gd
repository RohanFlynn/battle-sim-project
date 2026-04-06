extends TextureRect

const red_dude = preload("res://scenes/red_warrior.tscn")
var p = Vector2(0, 0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		p = get_global_mouse_position()
		var i_r = red_dude.instantiate()
		get_parent().add_child(i_r)
		i_r.global_position = p
	
func start():
	visible = false
