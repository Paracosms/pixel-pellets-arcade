shader_type canvas_item;

// shifts the hue
uniform float hueShift : hint_range(0, 1, 0.001) = 0;
uniform float amount = 1.0;

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
    if (tex.a <= 0.001) discard;

    vec3 hsv = rgb2hsv(tex.rgb);
    hsv.x = fract(hsv.x + hueShift);
    vec3 shifted = hsv2rgb(hsv);

    COLOR = vec4(mix(tex.rgb, shifted, amount), tex.a);
}