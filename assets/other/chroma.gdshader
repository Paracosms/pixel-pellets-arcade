shader_type canvas_item;
render_mode unshaded, blend_mix;

uniform float speed : hint_range(-2.0, 2.0, 0.01) = 0.15;
uniform float amount : hint_range(0.0, 1.0, 0.01) = 1.0;

uniform float rainbow_scale : hint_range(0.0, 10.0, 0.01) = 0.0;
uniform float rainbow_scroll : hint_range(-2.0, 2.0, 0.01) = 0.2;

/* NEW: make low-saturation areas livelier */
uniform float chroma_gain : hint_range(1.0, 4.0, 0.01) = 1.8;     // multiplies saturation
uniform float min_saturation : hint_range(0.0, 0.8, 0.01) = 0.15; // lift very pale colors

vec3 rgb2hsv(vec3 c){
    vec4 K = vec4(0.0, -1.0/3.0, 2.0/3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1e-10;
    return vec3(abs(q.z + (q.w - q.y)/(6.0*d + e)), d/(q.x + e), q.x);
}
vec3 hsv2rgb(vec3 c){
    vec3 p = abs(fract(c.xxx + vec3(0.0, 1.0/3.0, 2.0/3.0))*6.0 - 3.0);
    return c.z * mix(vec3(1.0), clamp(p - 1.0, 0.0, 1.0), c.y);
}

void fragment(){
    vec4 tex = texture(TEXTURE, UV);
    if (tex.a <= 0.001) { discard; }

    vec3 hsv = rgb2hsv(tex.rgb);

    // Hue offset over time (+ optional sweep)
    float hue_offset = TIME * speed;
    if (rainbow_scale > 0.0) {
        hue_offset += (UV.x + UV.y + TIME * rainbow_scroll) * rainbow_scale;
    }
    hsv.x = fract(hsv.x + hue_offset);

    // Boost saturation so pastels show the shift more
    hsv.y = clamp(max(hsv.y, min_saturation) * chroma_gain, 0.0, 1.0);

    vec3 shifted = hsv2rgb(hsv);
    COLOR = vec4(mix(tex.rgb, shifted, amount), tex.a);
}
