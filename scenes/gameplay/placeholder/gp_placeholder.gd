extends Control

# Press LMB/RMB to Win/Lose
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("SCENE CHANGE: Win")
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			print("SCENE CHANGE: Lose")
##
