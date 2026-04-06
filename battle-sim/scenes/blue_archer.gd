extends CharacterBody2D


const SPEED = 300.0

var starting = false
@onready var asprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var hitbox: Area2D = $hitbox
const arrow = preload("res://scenes/arrow.tscn")
var direction: Vector2
var attacking = false

func _physics_process(delta: float) -> void:
	animate()
	if starting:
		var target = get_closest_enemy()
		if target:
			navigation_agent.target_position = target.global_position
		var current_agent_position = global_position
		var next_path_position = navigation_agent.get_next_path_position()
		direction = current_agent_position.direction_to(next_path_position)
	move_and_slide()

func animate():
	if not attacking:
		if velocity.x != 0:
			asprite.play("run")
		else:
			asprite.play("idle")
	else:
		asprite.play("shoot")


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
