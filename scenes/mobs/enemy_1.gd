extends CharacterBody2D

enum {
	IDLE,
	ATTACK,
	CHASE
}

var state: int = 0:
	set(value):
		state = value
		match state :
			IDLE:
				idle_state()
			ATTACK:
				attack_state()
			CHASE:
				pass

@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()


func _on_attack_body_entered(body: Node2D) -> void:
	state = ATTACK

func idle_state():
	animPlayer.play("Idle")
	await get_tree().create_timer(1).timeout
	$AttackDirection/Attack/CollisionShape2D.disabled = false
	state = CHASE

func attack_state():
	animPlayer.play("Attack")
	await animPlayer.animation_finished
	
	$AttackDirection/Attack/CollisionShape2D.disabled = true
	
	state = IDLE
