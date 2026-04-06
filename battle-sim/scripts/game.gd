extends Node2D

var r = 1
var b = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start():
	pass

func killb():
	if get_tree().get_node_count_in_group("Blue") == 1:
		get_tree().call_group("ending_ui", "end", "Red")

func killr():
	if get_tree().get_node_count_in_group("Red") == 1:
		get_tree().call_group("ending_ui", "end", "Blue")
