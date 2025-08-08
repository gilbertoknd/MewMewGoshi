shader_type canvas_item;

uniform sampler2D pattern;
uniform float speed = 0.5;
uniform vec2 direction = vec2(1.0, 1.0);

void fragment() {
    float time = TIME * speed;
    vec2 offset_uv = UV + direction * time;
    COLOR = texture(pattern, fract(offset_uv));
}
