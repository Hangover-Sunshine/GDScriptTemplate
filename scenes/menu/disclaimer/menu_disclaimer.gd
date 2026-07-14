extends Control

@onready var is_disclaimed = false

# Disclaimer Animation
func _on_ap_labels_animation_finished(anim_name):
	if anim_name == "FadeIn":
		is_disclaimed = true
##

# Press ANY BUTTON To CONTINUE
func _input(event):
	if event.is_pressed() and is_disclaimed == true:
		print("SCENE Change: Splash") # Replace w/ signal
##
