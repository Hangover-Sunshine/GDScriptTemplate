extends Control

@onready var general = $Settings_MC/Settings_VBox/Tab_Vbox/Tab_Panel/Gen_Tab_Hbox
@onready var sound = $Settings_MC/Settings_VBox/Tab_Vbox/Tab_Panel/Audio_Tab_Vbox


signal settings_to_main
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_opt_gen_butt_pressed():
	general.visible = true
	sound.visible = false

func _on_opt_cont_butt_pressed():
	general.visible = false
	sound.visible = true

func _on_back_button_pressed():
	settings_to_main.emit()
