extends CharacterBody2D


const speed = 100

var starting = false
@onready var asprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var hitbox: Area2D = $hitbox
@onready var shootbox = $shootbox
@onready var runbox = $runbox
var rng = RandomNumberGenerator.new()

const arrow = preload("res://scenes/arrow.tscn")
var direction: Vector2
var attacking = false
var a
var in_m = false
var can_move = false
var hit_count = 0
var ummmmmm = false
var in_circ = false
var check_circ = false

func _physics_process(delta: float) -> void:
	animate()
	var bodies = shootbox.get_overlapping_bodies()
	if starting:
		var target = get_closest_enemy()
		if target:
			navigation_agent.target_position = target.global_position
		var current_agent_position = global_position
		var next_path_position = navigation_agent.get_next_path_position()
		direction = current_agent_position.direction_to(next_path_position)
		check_circ = true
		for body in bodies:
			if body.is_in_group("Red") and not in_m:
				attacking = true
				shoot_arrow()
			elif in_m and not ummmmmm:
				ummmmmm = true
				wait()
			if body.is_in_group("Red"):
				in_circ = true
				check_circ = false
		if check_circ == true:
			in_circ = false
		if not in_circ and check_circ == true:
			velocity = direction * speed
		else:
			velocity = Vector2(0, 0)
	move_and_slide()

func animate():
	if not attacking:
		if velocity.x != 0:
			asprite.play("run")
		else:
			asprite.play("idle")
	else:
		asprite.play("shoot")
		await asprite.animation_finished
		attacking = false


func shoot_arrow():
	in_m = true
	a = arrow.instantiate()
	add_child(a)
	var p = Vector2(0, 0)
	a.fire(p)

func start():
	starting = true
	can_move = true
	
func hit(d, dam):
	velocity.x += 40 * d.x
	velocity.y += 40 * d.y
	hit_count += dam
	if hit_count >= 3:
		get_tree().call_group("game", "killb")
		queue_free()

func wait():
	await get_tree().create_timer(rng.randf_range(0.6, 1.3)).timeout
	in_m = false
	ummmmmm = false
	
func get_closest_enemy():
	var red_e = get_tree().get_nodes_in_group("Red")
	var closest_enemy = null
	var closest_distance = INF
	for reds in red_e:
		var distance = global_position.distance_to(reds.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = reds
	return closest_enemy
