extends Control

# Buttons
func _on_button_leave_pressed():
	print("SCENE CHANGE: Previous Scene")
##

# Toggles
func _on_cb_fullscreen_toggled(toggled_on):
	GameSettings.FullScreen = toggled_on
	if GameSettings.FullScreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
##
