extends CharacterBody2D


const SPEED = -300.0
@onready var asprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var hitbox: Area2D = $hitbox
@onready var red = get_tree().get_first_node_in_group("Red")
var speed = 80
var direction: Vector2
var can_move = true
var attacking = false

func _physics_process(delta: float) -> void:
	animate()
	navigation_agent.target_position = red.global_position
	var current_agent_position = global_position
	var next_path_position = navigation_agent.get_next_path_position()
	direction = current_agent_position.direction_to(next_path_position)
	if can_move:
		velocity = direction * speed
	move_and_slide()
	
func animate():
	if not attacking:
		if velocity.x > 0 or velocity.x < 0:
			asprite.play("run")
			asprite.scale.x = direction.x
		else:
			asprite.play("idle")
	else:
		can_move = false
		asprite.play("attack1")
		await asprite.animation_finished
		asprite.play("attack2")
		await asprite.animation_finished
		get_tree().call_group("Red", "hit", direction)
		can_move = true
		attacking = false


func _on_hitbox_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if not body.is_in_group("Blue"):
		attacking = true

func hit(d):
	velocity.x += 400 * d.x
	velocity.y += 400 * d.y


func _on_hitbox_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if not body.is_in_group("Blue"):
		attacking = false
