shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float hue_shift : hint_range(0.0, 1.0) = 0.0;
uniform float threshold : hint_range(0.0, 0.2) = 0.1;

vec3 rgb_to_hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0/3.0, 2.0/3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

	float d = q.x - min(q.w, q.y);
	float e = 1e-10;
	return vec3(abs(q.z + (q.w - q.y)/(6.0*d + e)), d/(q.x + e), q.x);
}

vec3 hsv_to_rgb(vec3 c) {
	vec3 p = abs(fract(c.xxx + vec3(0.0, 1.0/3.0, 2.0/3.0)) * 6.0 - 3.0);
	return c.z * mix(vec3(1.0), clamp(p - 1.0, 0.0, 1.0), c.y);
}

void fragment() {
	vec4 pixelColor = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec3 hsv = rgb_to_hsv(pixelColor.rgb);

	if (hsv.z > threshold && hsv.y > threshold) { // skip desaturated/dark objects cos hsv is polar and gets messy there
		hsv.x = mod(hsv.x + hue_shift, 1.0);
		pixelColor.rgb = hsv_to_rgb(hsv);
	}

	COLOR = pixelColor;
}
