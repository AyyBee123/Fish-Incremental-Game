shader_type spatial;
render_mode cull_front, unshaded, depth_draw_never, blend_mix;

stencil_mode read, compare_not_equal, 1;

uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
global uniform float outline_width;

void vertex() {
	vec4 clip_position = PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX, 1.0);

	vec3 view_normal = normalize(MODELVIEW_NORMAL_MATRIX * NORMAL);
	vec4 clip_normal = PROJECTION_MATRIX * vec4(view_normal, 0.0);

	vec2 direction = clip_normal.xy;

	if (length(direction) > 0.0001) {
		direction = normalize(direction);

		clip_position.xy += direction * (outline_width * 2.0 / VIEWPORT_SIZE) * clip_position.w;
	}

	POSITION = clip_position;
}

void fragment() {
	ALBEDO = outline_color.rgb;
	ALPHA = outline_color.a;
}