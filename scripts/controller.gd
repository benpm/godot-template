# The game controller singleton

extends Node2D

onready var zone_tween := Tween.new()
onready var music := AudioStreamPlayer.new()
onready var soundFX := Node2D.new()
onready var player: KinematicBody2D = $'../scene/player'

var sounds: Dictionary

# Called on game start
func _ready() -> void:

	# Load all the audio
	var audioDir = Directory.new()
	audioDir.open("res://audio/")
	audioDir.list_dir_begin(true, true)
	var fname = audioDir.get_next()
	while fname:
		if fname.get_extension() == "ogg":
			var streamName: String = fname.get_basename()
			var stream: AudioStreamOGGVorbis = load("res://audio/" + fname)
			stream.loop = false
			var streamPlayer = AudioStreamPlayer2D.new()
			streamPlayer.name = streamName
			streamPlayer.stream = stream
			streamPlayer.autoplay = false
			streamPlayer.bus = "FX"
			streamPlayer.attenuation = 2.0
			sounds[streamName] = streamPlayer
			soundFX.add_child(streamPlayer)
		fname = audioDir.get_next()
	
	sounds["walk"].stream.loop = true
	add_child(soundFX)

	zone_tween.repeat = false
	add_child(zone_tween)

	# music.stream = load("res://audio/music.mp3")
	# music.stream.loop = true
	# music.play()
	# music.volume_db = -7.0
	# add_child(music)
# Call to play a sound
func play_sound(name: String, pos = null):
	sounds[name].stop()
	if pos != null:
		sounds[name].position = pos
	sounds[name].play()
# Set sounds to playing or not
func sound_playing(name: String, playing: bool, pos = null):
	if sounds[name].playing != playing:
		sounds[name].playing = playing
	if pos != null:
		sounds[name].position = pos
