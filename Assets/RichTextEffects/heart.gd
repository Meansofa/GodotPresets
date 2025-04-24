@tool
extends RichTextEffect
class_name heart

# Syntax: [heart scale=1.0 freq=8.0][/heart]
var bbcode = "heart" #how it's going to be instantiated

const HEART = "♡"
const TO_CHANGE = ["o", "O", "a", "A"]

func _process_custom_fx(char_fx):
	var scale:float = char_fx.env.get("scale", 10.0) #wave
	var freq:float = char_fx.env.get("freq", 2.0) #speed
	var jump_height:float = 4.0

	var x =  char_fx.relative_index / scale - char_fx.elapsed_time * freq
	var t = abs(cos(x)) * max(0.0, smoothstep(0.712, 0.99, sin(x))) * 2.5; #alpha
	char_fx.color = lerp(char_fx.color, lerp(Color(219/255.0, 181/255.0, 181/255.0, 1), Color(2559/255.0, 181/255.0, 255/255.0, 1), t), t) # color mode
	char_fx.offset.y -= t * jump_height # jumping
	
	#var c = char_fx
	#if char_fx.offset.y < -1.0:
		#if char_fx in TO_CHANGE:
			#char_fx = HEART
	
	return true
