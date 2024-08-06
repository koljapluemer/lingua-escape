extends CharacterBody2D

signal target_reached

@export var speed : float = 100.0
@export var jump_velocity : float = -150.0
@export var double_jump_velocity : float = -100

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2 = Vector2.ZERO


var target: Node2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# if target set, move towards target
	# this is an NPC, NOT player-controlled at all
	if target:
		direction = target.global_position - global_position
		direction = direction.normalized()
		velocity.x = direction.x * speed
		velocity.y = direction.y * speed
		move_and_slide()
		update_animation()
		update_facing_direction()
		# if closer than 10 units, stop
		# set target to null, go idle
		if global_position.distance_to(target.global_position) < 10:
			target = null
			velocity = Vector2.ZERO
			animated_sprite.play("idle")
			target_reached.emit()

func set_target(tar):
	target = tar
	
func update_animation():
	if direction.x != 0:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")

func update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = true
	elif direction.x < 0:
		animated_sprite.flip_h = false
		
