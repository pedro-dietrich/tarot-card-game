shader_type spatial;

uniform sampler2D base_albedo : source_color;

uniform sampler2D background : source_color;
uniform sampler2D middleground : source_color;
uniform sampler2D foreground : source_color;

void fragment() {
	vec4 base_color = texture(base_albedo, UV);

	vec2 base_uv = vec2(3.3 * (UV.x - 0.655), 2.0 * (UV.y - 0.5));

	vec4 bg_color = texture(background, base_uv);
	vec4 mg_color = texture(middleground, base_uv);
	vec4 fg_color = texture(foreground, base_uv);

	if(base_color.r < 0.1 && base_color.g > 0.75 && base_color.b < 0.1) {
		base_color.rgb = bg_color.rgb;
		if(mg_color.a > 0.8)
			base_color.rgb = mg_color.rgb;
		if(fg_color.a > 0.8)
			base_color.rgb = fg_color.rgb;
	}

	ALBEDO = base_color.rgb;
	ALPHA = 1.0;
}
