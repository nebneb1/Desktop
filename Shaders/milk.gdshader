shader_type canvas_item;

uniform vec4 bright : source_color;
uniform vec4 medium : source_color;
uniform vec4 dark : source_color;

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	if (pixelColor.r > 0.6){
		pixelColor = bright;
	} else if (pixelColor.r > 0.1){
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
