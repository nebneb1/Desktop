shader_type canvas_item;

uniform vec4 bright : source_color;
uniform vec4 medium : source_color;
uniform vec4 dark : source_color;

uniform float bright_thresh : hint_range(0.0, 1.0) = 0.6;
uniform float medium_thresh : hint_range(0.0, 1.0) = 0.3;

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	pixelColor.r = (pixelColor.g + pixelColor.b + pixelColor.r) / 3.0;
	if (pixelColor.r > bright_thresh){
		pixelColor = bright;
	} else if (pixelColor.r > medium_thresh){
		pixelColor = medium;
	} else {
		pixelColor = dark;
	}
	COLOR = pixelColor;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
