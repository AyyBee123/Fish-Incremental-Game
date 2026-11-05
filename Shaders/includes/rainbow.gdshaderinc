uniform sampler2D rainbow_gradient : source_color, filter_linear;
uniform float rainbow_speed = 0.2;
uniform float rainbow_length = 0.5;
uniform float rainbow_strength : hint_range(0.0, 1.0) = 0.7;

varying vec3 local_position;

vec3 rainbow_effect() {
	float position = fract(local_position.z * rainbow_length + TIME * rainbow_speed);
	return texture(rainbow_gradient, vec2(position, 0.5)).rgb;
}
