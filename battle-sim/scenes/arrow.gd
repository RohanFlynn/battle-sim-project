extends CharacterBody2D


const speed = 200
const JUMP_VELOCITY = -400.0
var target = false
@onready var hitbox = $Area2D
var d
func _physics_process(delta: float) -> void:
	if target:
		velocity = transform.x * speed
		for body in hitbox.get_overlapping_bodies():
			if body and body.is_in_group("Red"):
				var direction = transform.x.normalized()
				body.hit(direction, 0.75)
				queue_free()
			elif body and body.is_in_group("walls"):
				queue_free()
	move_and_slide()
	
func fire(a):
	var e = get_closest_enemy()
	d = get_angle_to(e.position)
	rotate(d)
	position = a
	target = true
	
	
func get_closest_enemy():
	var red_e = get_tree().get_nodes_in_group("Red")
	var closest_enemy = null
	var closest_distance = INF
	for reds in red_e:
		var distance = global_position.distance_to(reds.position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = reds
	return closest_enemy
	
