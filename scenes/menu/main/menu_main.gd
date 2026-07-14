extends Control

# Buttons
func _on_button_play_pressed():
	print("SCENE CHANGE: Gameplay")

func _on_button_settings_pressed():
	print("SCENE CHANGE: Settings")

func _on_button_exit_pressed():
	get_tree().quit()
##
