extends Node2D

@onready var menu_disclaimer = $MenuDisclaimer
@onready var menu_splash = $MenuSplash
@onready var menu_main = $MenuMain
@onready var menu_pregame = $MenuPregame
@onready var menu_settings = $MenuSettings
@onready var animplayer = $HubMenu_AnimPlayer

var was_disclaimed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if was_disclaimed == false:
		animplayer.play("ToDisclaimer")
	elif was_disclaimed == true:
		animplayer.play("ToSplash")
	
	handle_signals()

func _input(event):
	if event.is_pressed() and menu_splash.visible == true and menu_disclaimer.visible == false:
		to_main()
	elif event.is_pressed() and menu_splash.visible == false and menu_disclaimer.visible == true:
		to_splash()

func handle_signals():
	menu_disclaimer.was_disclaimed.connect(disclaimed)
	menu_main.main_to_pregame.connect(to_pregame)
	menu_main.main_to_settings.connect(to_settings)
	menu_main.main_to_exit.connect(to_exit)
	menu_pregame.pregame_to_main.connect(to_main)
	menu_pregame.pregame_to_game.connect(to_load)
	menu_settings.settings_to_main.connect(to_main)
	GlobalSignals.connect("scene_loaded", to_free)

func disclaimed():
	was_disclaimed == true

func to_splash():
	animplayer.play("ToSplash")

func to_main():
	animplayer.play("ToMain")

func to_pregame():
	animplayer.play("ToPregame")

func to_settings():
	animplayer.play("ToSettings")

func to_exit():
	get_tree().quit()

func to_load():
	GlobalSignals.emit_signal("load_scene", "DummySceneA")

func to_free(scene_name):
	self.queue_free()
