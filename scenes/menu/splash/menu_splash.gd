extends Control

@onready var is_splashed = false

# Disclaimer Animation
func _on_ap_labels_animation_finished(anim_name):
	if anim_name == "FadeIn":
		is_splashed = true
##

# Press ANY BUTTON To CONTINUE
func _input(event):
	if event.is_pressed() and is_splashed == true:
		print("SCENE Change: Main") # Replace w/ signal
##
