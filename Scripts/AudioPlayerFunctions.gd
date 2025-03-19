extends Node
class_name AudioPlayerFunctions

func _ready() -> void:
	name = "AudioPlayerParent"

func play_sound(stream : AudioStream):
	if stream == null:
		return
	 # Step 1: Create a new AudioStreamPlayer
	var audio_player = AudioStreamPlayer.new()
	
	# Step 3: Set the audio stream to the AudioStreamPlayer
	audio_player.stream = stream
	audio_player.bus = "SFX"
	audio_player.pitch_scale = randf_range(0.8, 1.2)
	
	# Step 4: Add the audio player to the scene tree
	add_child(audio_player)
	
	# Step 5: Play the audio
	audio_player.play()
	
	# Optional: Queue free the audio player after it's done playing if it's a one-time sound
	audio_player.connect("finished", _remove_audio_player.bind(audio_player))

func _remove_audio_player(audio_player : AudioStreamPlayer):
	#print("audio_player: ", audio_player)
	remove_child(audio_player)
	audio_player.queue_free()
	#print("audio_player removed: ", audio_player)
