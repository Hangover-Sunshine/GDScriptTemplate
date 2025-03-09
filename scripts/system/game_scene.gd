extends Node2D

func _input(event):
	if event.is_action_pressed("pause"):
		pause_unpause()
	##
##

func pause_unpause():
	GlobalSignals.pause_status.emit(!get_tree().paused)
	get_tree().paused = !get_tree().paused
	$CanvasLayer.visible = get_tree().paused
	$CanvasLayer/HubPause.to_pause()
##
