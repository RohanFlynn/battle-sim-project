extends Label

var b = 4
var r = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "Blue:"+str(b)+"                         Red:"+str(r)

func update(n):
	if n == 0:
		b += 1
	else:
		r += 1

func start():
	visible = false
