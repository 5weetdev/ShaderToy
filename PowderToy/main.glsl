//#define DRAW_BUFFER_B

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;

    vec3 col = texture(iChannel0, uv).rgb;

    // Draw UI
    InitButtons();
    previewBrush.position += vec2(0.0, iResolution.y);
    for(int i = 0; i < BUTTON_COUNT; i++) {
        if(isInsideRect(fragCoord, buttons[i])){
            col = buttons[i].color;
        }
    }
    
    if(isInsideRect(fragCoord, previewBrush)) {
        col = vec3(texture(iChannel1, vec2(0.0)).rgb);
    }

#ifdef DRAW_BUFFER_B
    vec3 bufB = texture(iChannel1, uv).rgb;
    if(bufB.x > 0.1){
        col = bufB;
    }
#endif

    fragColor = vec4(col, 1.0);
}