shader_type spatial;
render_mode cull_front, unshaded, depth_draw_never, blend_mix;

instance uniform bool is_highlighted = false;

global uniform vec4 highlight_color;
global uniform float highlight_width;

void vertex() {
	if (is_highlighted) {
		vec4 clip_position = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
		vec3 clip_normal = mat3(PROJECTION_MATRIX) * (mat3(MODELVIEW_MATRIX) * NORMAL);
		vec2 dir = clip_normal.xy;
		if (length(dir) > 0.0001) {
			dir = normalize(dir);
			clip_position.xy += dir / VIEWPORT_SIZE * clip_position.w * highlight_width;
		}
		POSITION = clip_position;
	}
}

void fragment() {
	ALBEDO = highlight_color.rgb;
	ALPHA = highlight_color.a;   // writing ALPHA puts it in the transparent pass
}