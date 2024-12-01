extends Control

func _ready() -> void:
	$MarginContainer/MainButtons.visible = true
	$MarginContainer/SettingsButtons.visible = false

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1/level_1.tscn")

func _on_settings_pressed() -> void:
	$MarginContainer/MainButtons.visible = false
	$MarginContainer/SettingsButtons.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	$MarginContainer/MainButtons.visible = true
	$MarginContainer/SettingsButtons.visible = false
