shader_type canvas_item;

uniform vec4 from_white : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 from_gray  : source_color = vec4(0.5, 0.5, 0.5, 1.0);

void fragment() {
    vec4 input_color = texture(TEXTURE, UV);

    if (distance(input_color, vec4(0.5, 0.5, 0.5, 1.0)) < 0.01) {
        COLOR = from_gray;
    } else if (input_color == vec4(1.0, 1.0, 1.0, 1.0)) {
        COLOR = from_white;
    }
}