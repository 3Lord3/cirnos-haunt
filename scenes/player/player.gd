extends CharacterBody2D

signal health_changed(new_health)

const SPEED = 180.0
const JUMP_VELOCITY = -250.0

enum {
	RUN,
	JUMP,
	ATTACK,
	DEATH,
	FALL,
	DAMAGE
}

@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer

var state = RUN
var health
var max_health = 100
var rubies = 0
var player_pos

func _ready():
	Signals.connect("enemy_attack", Callable(self, "_on_damage_received"))
	health = max_health

func _physics_process(delta: float) -> void:
	match state:
		RUN:
			run_state()
		JUMP:
			jump_state()
		ATTACK:
			attack_state()
		DEATH:
			death_state()
		FALL:
			pass
		DAMAGE:
			damage_state()
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if velocity.y > 0:
		animPlayer.play("Fall")

	move_and_slide()
	
	player_pos = self.position
	Signals.emit_signal("player_position_update", player_pos)

func run_state():
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			animPlayer.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			animPlayer.play("Idle")
			
	if direction == -1:
		anim.flip_h = true
	elif direction == 1:
		anim.flip_h = false
		
	if Input.is_action_just_pressed("Attack") and is_on_floor():
		state = ATTACK
		
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		state = JUMP

func jump_state():
	velocity.y = JUMP_VELOCITY
	animPlayer.play("Jump")
	state = RUN

func attack_state():
	velocity.x = 0
	animPlayer.play("Attack")
	if Input.is_action_just_released("Attack"):
		state = RUN

func death_state():
	velocity.x = 0
	
	animPlayer.play("Death")
	await animPlayer.animation_finished
	
	queue_free()
	get_tree().change_scene_to_file.bind("res://scenes/menu/menu.tscn").call_deferred()
	
func damage_state():
	velocity.x = 0
	animPlayer.play("Damage")
	await anim.animation_finished
	state = RUN

func _on_damage_received(enemy_damage):
	health -= enemy_damage
	
	if health <= 0:
		health = 0
		state = DEATH
	else:
		state = DAMAGE
	emit_signal("health_changed", health)
