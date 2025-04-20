shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec4 bright : source_color;
uniform vec4 medium : source_color;
uniform vec4 dark : source_color;

void fragment() {
	vec4 pixelColor = texture(SCREEN_TEXTURE, SCREEN_UV);
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
