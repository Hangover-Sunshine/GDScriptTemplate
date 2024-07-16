extends Node

# Exports ########################################
@export var scene_folder_path:String = "scenes/"
@export var curr_scene:Node

@export_category("Transition Fade")
## The default name of the animation string. Leave blank to be set automatically
##	when the game starts. This will be the alphabetical zeroth (e.g., "A" comes before "B").
##	Will also auto-default to alphabetical zeroth if animation doesn't exist.
@export var DefaultTransitionAnim:String
@export var PlayFadeFully:bool = false
@export var StayFaded:bool = false
@export var StayFadedTime:float = 2.5
# Exports ########################################

@onready var transition_player:AnimationPlayer = $TransitionPlayer
@onready var StayFadedTimer:Timer = $StayFadedTimer

var transition_anims:PackedStringArray

var undo_load_overlay:bool = false

var scene_name:String
var scene_path:String

var fade_in:bool = false
var fade_completed:bool = false

func _ready():
	GlobalSignals.connect("load_scene", _load_scene)
	GlobalSignals.connect("load_scene_with_anim", _load_scene_with_anim)
	MusicManager.loaded.connect(on_music_manager_loaded)
	
	# TODO: Inform Godot this is bad and I should just be able to get a list of
	#	all animations rather than peek into the property list (which may break in
	#	an update)
	for prop in transition_player.get_property_list():
		if prop["name"] == "current_animation":
			transition_anims = str(prop["hint_string"]).split(",")
			transition_anims.remove_at(0) # remove [stop]
		##
	##
	
	if DefaultTransitionAnim == "":
		if len(transition_anims) > 0:
			DefaultTransitionAnim = transition_anims[0]
		else:
			printerr("Error: no animations detected in transition animation player!")
		##
	else:
		var found:bool = false
		for ta in transition_anims:
			if ta.to_lower() == DefaultTransitionAnim.to_lower():
				found = true
				DefaultTransitionAnim = ta
				break
			##
		##
		
		if found == false:
			printerr("Error: '%s' was not found, defaulting to '%s'!" %
				[DefaultTransitionAnim, transition_anims[0]])
			DefaultTransitionAnim = transition_anims[0]
		##
	##
##

func _process(_delta):
	var progress = []
	
	var thread_status:int = ResourceLoader.load_threaded_get_status(scene_path, progress)
	
	# The following two if-statements are fail-safes because multi-threaded loading is tricky and it's best
	# 	to know what's happening with multi-threading stuff. These should never ever ever ever ever
	#	be touched if we have already loaded the scene, more if something goes wrong DURING loading.
	
	# if it's not done or loaded
	if thread_status == 2:
		print("An error has occured loading ", scene_name, "!")
		return # stop!
	elif thread_status == 0:
		print("The scene ", scene_name, " is invalid or not loaded properly!")
		print("Provided path: ", scene_path)
		return # stop!
	##
	
	progress = progress[0]
	
	if progress >= 1 and (PlayFadeFully == false || (fade_completed and StayFadedTimer.is_stopped())):
		# inform the prior scene it's time to clean up
		GlobalSignals.emit_signal("scene_loaded", scene_name)
		curr_scene.z_index = -100
		
		# get the new scene from the resource loader and instantiate it
		var new_scene = ResourceLoader.load_threaded_get(scene_path).instantiate()
		
		# the new scene is our current scene, we don't care what happens with the other one
		curr_scene = new_scene
		add_child(new_scene)
		
		# play the animation player and make sure it knows we're fading in
		fade_in = true
		transition_player.play("Fade")
		
		# stop from coming back here
		set_process(false)
	else:
		# do something else...
		print(progress)
	##
##

func _load_scene(scene:String):
	_load_scene_with_anim(scene, DefaultTransitionAnim)
##

func _load_scene_with_anim(scene:String, anim_name:String):
	if anim_name != DefaultTransitionAnim:
		var found:bool = false
		for ta in transition_anims:
			if ta.to_lower() == anim_name.to_lower():
				found = true
				anim_name = ta
				break
			##
		##
		
		if found == false:
			printerr("Error: '%s' was not found, defaulting to '%s'!" %
				[anim_name, DefaultTransitionAnim])
			anim_name = DefaultTransitionAnim
		##
	##
	
	scene_path = "res://" + scene_folder_path + scene + ".tscn"
	scene_name = scene
	
	# async loading...
	var error = ResourceLoader.load_threaded_request(scene_path)
	
	# if there's an error, break out and report -- DO NOT CONTINUE!
	if error:
		print("Unable to load scene as a request: %s!", scene_path)
		return
	##
	
	GlobalSignals.emit_signal("scene_transition_started")
	
	transition_player.play_backwards("Fade")
	fade_in = false
	fade_completed = false
	
	set_process(true)
##

func _on_transition_player_animation_finished(anim_name):
	if fade_in:
		GlobalSignals.emit_signal("scene_transition_done")
	##
	
	if PlayFadeFully:
		if StayFaded:
			StayFadedTimer.start(StayFadedTime)
		##
		fade_completed = true
	##
##

func on_music_manager_loaded():
	# Resonate has completed loading, good to load the game from here
	set_process(false)
	# TODO: Replace with transition events -- maybe I don't want to use the default
	#		on load?
	transition_player.play(DefaultTransitionAnim)
##
