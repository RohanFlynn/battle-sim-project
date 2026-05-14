extends CharacterBody2D


const SPEED = -400.0
@onready var asprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var hitbox: Area2D = $hitbox
@onready var blue = get_tree().get_first_node_in_group("Blue")
var speed = 90
var direction: Vector2
var can_move = false
var attacking = false
var dir = 0
var rng = RandomNumberGenerator.new()
var hit_count = 0
var starting = false

func _physics_process(delta: float) -> void:
	animate()
	if starting:
		var target = get_closest_enemy()
		if target:
			navigation_agent.target_position = target.global_position
		var current_agent_position = global_position
		var next_path_position = navigation_agent.get_next_path_position()
		direction = current_agent_position.direction_to(next_path_position)
		var bodies = hitbox.get_overlapping_bodies()
		for body in bodies:
			if body and body.is_in_group("Blue"):
				attacking = true
			else:
				attacking = false
				can_move = true
		if can_move:
			velocity = direction * speed
		else:
			velocity = Vector2(0, 0)
		move_and_slide()
	
func animate():
	if direction.x < 0:
		dir = -1
	else:
		dir = 1
	if not attacking:
		if velocity.x > 0 or velocity.x < 0:
			asprite.play("run")
			asprite.scale.x = dir
		else:
			asprite.play("idle")
	else:
		rng.randomize()
		await get_tree().create_timer(rng.randf_range(0.1, 1.0)).timeout
		can_move = false
		asprite.play("attack1")
		await asprite.animation_finished
		asprite.play("attack2")
		await asprite.animation_finished
		var bodies = hitbox.get_overlapping_bodies()
		for body in bodies:
			if body and body.is_in_group("Blue"):
				body.hit(direction, 1)
				break


func _on_hitbox_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body and not body.is_in_group("Red"):
		velocity *= 0
		attacking = true


func hit(d, dam):
	velocity.x += 40 * d.x
	velocity.y += 40 * d.y
	hit_count += dam
	if hit_count >= 3:
		get_tree().call_group("game", "killr")
		queue_free()


func _on_hitbox_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body and not body.is_in_group("Red"):
		attacking = false
		can_move = true

func get_closest_enemy():
	var blue_e = get_tree().get_nodes_in_group("Blue")
	var closest_enemy = null
	var closest_distance = INF
	for blues in blue_e:
		var distance = global_position.distance_to(blues.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = blues
	return closest_enemy

func start():
	can_move = true
	starting = true
	
