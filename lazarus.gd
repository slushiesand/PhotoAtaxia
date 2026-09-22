class_name Player extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0

func _physics_process(delta: float) -> void:
	
	var direction := Input.get_axis("left", "right")
	
	if direction:
		$AnimationPlayer.play("walk")
		velocity.x = direction * SPEED
	else:
		$AnimationPlayer.play("idle")
		velocity.x = (move_toward(velocity.x, 0, SPEED))
		
		
	if not is_on_floor():
		velocity += get_gravity() * delta
		#shouldn't ever happen, but just as a precaution to keep the player grounded.
		
	move_and_slide()
