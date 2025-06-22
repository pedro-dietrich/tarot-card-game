shader_type spatial;

uniform sampler2D base_albedo : source_color;

uniform sampler2D background : source_color;
uniform sampler2D middleground : source_color;
uniform sampler2D foreground : source_color;

const float bg_strength = 0.05f;
const float mg_strength = 0.10f;
const float fg_strength = 0.20f;

void fragment() {
	vec4 base_color = texture(base_albedo, UV);

	vec2 shift = vec2(VIEW.x, -VIEW.y) + CAMERA_DIRECTION_WORLD.zx;

	vec2 base_uv = vec2(3.3 * (UV.x - 0.655), 2.0 * (UV.y - 0.5));
	vec2 bg_uv = (1.0 - 2.0 * bg_strength) * base_uv + vec2(bg_strength);
	vec2 mg_uv = (1.0 - 2.0 * mg_strength) * base_uv + vec2(mg_strength);
	vec2 fg_uv = (1.0 - 2.0 * fg_strength) * base_uv + vec2(fg_strength);

	vec4 bg_color = texture(background, bg_uv + (bg_strength * shift));
	vec4 mg_color = texture(middleground, mg_uv + (mg_strength * shift));
	vec4 fg_color = texture(foreground, fg_uv + (fg_strength * shift));

	if(base_color.g > 0.9) {
		base_color.rgb = bg_color.rgb;
		if(mg_color.a > 0.8)
			base_color.rgb = mg_color.rgb;
		if(fg_color.a > 0.8)
			base_color.rgb = fg_color.rgb;
	}

	ALBEDO = base_color.rgb;
	ALPHA = 1.0;
}
