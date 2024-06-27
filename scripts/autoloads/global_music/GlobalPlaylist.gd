extends Node

var playlist:Array[AudioStreamPlayer] = []
var names_to_ids:Dictionary = {}

var prev_play:int = -1
var curr_play:int = -1

var change_tracks:bool = false

func _ready():
	var children = get_children()
	var music_bus = AudioServer.get_bus_index("Music")
	
	for ci in range(get_child_count()):
		if children[ci] is AudioStreamPlayer:
			names_to_ids[children[ci].name] = len(playlist)
			playlist.append(children[ci])
			children[ci].set_bus(music_bus) # just force all audio tracks here to be on the Music track
		else:
			printerr("Non-AudioStreamPlayer child detected at index %s!", ci)
		##
	##
##

func play_by_id(i:int, fade_out_time:float = 10, fade_in_time:float = 10):
	if curr_play != -1:
		playlist[i].volume_db = -80
		playlist[curr_play].fade_out(fade_out_time)
	##
	
	curr_play = i
	
	playlist[curr_play].fade_in(fade_in_time)
##

func current_song() -> String:
	if curr_play == -1:
		return "None"
	##
	return names_to_ids.find_key(curr_play)
##

func play(song_name:String, fade_out_time:float = 10, fade_in_time:float = 10):
	if song_name in names_to_ids.keys():
		#print(song_name, " is ID ", names_to_ids[song_name])
		play_by_id(names_to_ids[song_name], fade_out_time, fade_in_time)
	##
##

func stop_playing(fade_out_time:float = 2.5):
	if is_equal_approx(fade_out_time, 0) or fade_out_time < 0:
		playlist[curr_play].stop()
	else:
		playlist[curr_play].fade_out(fade_out_time)
	##
	curr_play = -1
##
