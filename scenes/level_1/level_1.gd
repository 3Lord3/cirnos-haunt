extends Node2D

@onready var health_bar = $CanvasLayer/HealthBar
@onready var player = $Player/Player

func _ready():
	health_bar.max_value = player.max_health
	health_bar.value = health_bar.max_value

func _on_player_health_changed(new_health):
	health_bar.value = new_health
