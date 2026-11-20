shader_type canvas_item;

uniform vec4 tint_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float outline_width : hint_range(0.0, 16.0, 0.5) = 4.0;

uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 0.5);
uniform vec2 shadow_offset = vec2(4.0, 4.0);

// alpha of the fish plus its outline at a given position
float silhouette(sampler2D tex, vec2 uv, vec2 px, float width) {
	float a = texture(tex, uv).a;
	for (int i = 0; i < 16; i++) {
		float angle = float(i) * TAU / 16.0;
		vec2 offset = vec2(cos(angle), sin(angle)) * width * px;
		a = max(a, texture(tex, uv + offset).a);
	}
	return a;
}

// layering
vec4 over(vec4 top, vec4 bottom) {
	float a = top.a + bottom.a * (1.0 - top.a);
	vec3 rgb = (top.rgb * top.a + bottom.rgb * bottom.a * (1.0 - top.a)) / max(a, 0.0001);
	return vec4(rgb, a);
}

void fragment() {
	vec2 px = TEXTURE_PIXEL_SIZE;
	
	float fill_a    = texture(TEXTURE, UV).a;
	float outline_a = silhouette(TEXTURE, UV, px, outline_width);
	float shadow_a  = silhouette(TEXTURE, UV - shadow_offset * px, px, outline_width);
	
	vec4 fill    = vec4(tint_color.rgb,    fill_a    * tint_color.a);
	vec4 outline = vec4(outline_color.rgb, outline_a * outline_color.a);
	vec4 shadow  = vec4(shadow_color.rgb,  shadow_a  * shadow_color.a);
	
	// shadow at the back, then outline, then fill on top
	COLOR = over(fill, over(outline, shadow));
}