shader_type spatial;

uniform sampler2D base_albedo : source_color;

uniform sampler2D background : source_color;
uniform sampler2D middleground : source_color;
uniform sampler2D foreground : source_color;

uniform uint current_frame = 0;


const vec2 FRAME_SIZE = vec2(1.0 / 6.0, 1.0 / 4.0);


void fragment() {
	vec4 base_color = texture(base_albedo, UV);

	vec2 base_uv = vec2(3.3 * (UV.x - 0.655), 2.0 * (UV.y - 0.5));

	vec2 frame_offset = vec2(float(current_frame % 6U), float(current_frame / 6U)) * FRAME_SIZE;

	vec2 tex_uv = base_uv * FRAME_SIZE + frame_offset;

	vec4 bg_color = texture(background, base_uv);
	vec4 mg_color = texture(middleground, tex_uv);
	vec4 fg_color = texture(foreground, tex_uv);

	if(base_color.r < 0.1 && base_color.g > 0.75 && base_color.b < 0.1) {
		base_color.rgb = fg_color.a * fg_color.rgb +
			(1.0 - fg_color.a) * (mg_color.a * mg_color.rgb + (1.0 - mg_color.a) * bg_color.rgb);
	}

	ALBEDO = base_color.rgb;
	ALPHA = 1.0;
}
