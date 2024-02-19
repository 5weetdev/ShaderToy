void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 pix = 1.0 / iResolution.xy;

    vec3 col = texture(iChannel1, uv).rgb;

    // UI bounding boxes
    InitButtons();

    if(fragCoord.x <= 10.0 && fragCoord.y <= 10.0) {
        if(isInsideRect(iMouse.zw, buttons[1])) {
            col = vec3(VOID);
        } else if(isInsideRect(iMouse.zw, buttons[2])) {
            //col = vec3(clamp((rand(iMouse.zw) - 1.0) * 0.2 + STONE, 0.0, 1.0));
            col = vec3(STONE);
        } else if(isInsideRect(iMouse.zw, buttons[3])) {
            col = vec3(WATER);
        }

        // Randomize stone color
        if(col.x <= STONE && col.x > WATER){
            col = vec3(clamp((rand(iMouse.zw) - 1.0) * 0.2 + STONE, 0.0, 1.0));
        }
        //col = vec3(1.0);
    }

    fragColor = vec4(col, 1.0);
}