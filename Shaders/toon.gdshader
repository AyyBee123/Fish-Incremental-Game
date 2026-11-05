shader_type spatial;
render_mode diffuse_toon, specular_toon;

uniform sampler2D fish_texture : source_color;

void fragment() {
    ALBEDO = texture(fish_texture, UV).rgb;
}
