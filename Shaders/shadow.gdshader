shader_type canvas_item;

uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 0.5);
uniform vec2 shadow_offset = vec2(8.0, 8.0);

// Standard "A over B" layering
vec4 over(vec4 top, vec4 bottom) {
	float a = top.a + bottom.a * (1.0 - top.a);
	vec3 rgb = (top.rgb * top.a + bottom.rgb * bottom.a * (1.0 - top.a)) / max(a, 0.0001);
	return vec4(rgb, a);
}

void fragment() {
	vec4 fish = texture(TEXTURE, UV);
	float shadow_a = texture(TEXTURE, UV - shadow_offset * TEXTURE_PIXEL_SIZE).a;
	vec4 shadow = vec4(shadow_color.rgb, shadow_a * shadow_color.a);

	COLOR = over(fish, shadow);
}