shader_type spatial;

render_mode cull_front, unshaded, depth_draw_never;

global uniform vec4 highlight_color;
global uniform float highlight_width;
instance uniform bool enabled = false;

void vertex() {
	if (enabled) {
		vec4 clip_position = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
		vec3 clip_normal = mat3(PROJECTION_MATRIX) * (mat3(MODELVIEW_MATRIX) * NORMAL);
		clip_position.xy += normalize(clip_normal.xy) / VIEWPORT_SIZE * clip_position.w * highlight_width;
		POSITION = clip_position;
	}
}

void fragment() {
	ALBEDO = highlight_color.rgb;
}
