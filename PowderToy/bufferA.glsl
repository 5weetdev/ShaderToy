#define TRESHOLD 0.01

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 pix = 1.0 / iResolution.xy;

    vec3 col = texture(iChannel0, uv).rgb;

    vec3 up = texture(iChannel0, uv + vec2(0.0, pix.y)).rgb;
    vec3 upRight = texture(iChannel0, uv + vec2(pix.x, pix.y)).rgb;
    vec3 upLeft = texture(iChannel0, uv + vec2(-pix.x, pix.y)).rgb;

    vec3 down = texture(iChannel0, uv + vec2(0.0, -pix.y)).rgb;
    vec3 downRight = texture(iChannel0, uv + vec2(pix.x, -pix.y)).rgb;
    vec3 downLeft = texture(iChannel0, uv + vec2(-pix.x, -pix.y)).rgb;

    vec3 right = texture(iChannel0, uv + vec2(pix.x, 0.0)).rgb;
    vec3 left = texture(iChannel0, uv + vec2(-pix.x, 0.0)).rgb;

    // TODO ADD WATER
    if(col.x < TRESHOLD) {
        // If its empty cell
        if(up.x > TRESHOLD) {
            col = up;
        } else if(upRight.x > TRESHOLD && right.x > TRESHOLD) {
            col = upRight;
        } else if(upLeft.x > TRESHOLD && left.x > TRESHOLD) {
            col = upLeft;
        } else if(right.x > TRESHOLD && right.x <= WATER) {
            col = right;
        } else if(left.x > TRESHOLD && left.x <= WATER) {
            col = left;
        }
    } else {
        // If cell contains something
        if(col.x <= WATER) {
            if(down.x < TRESHOLD) {
                col = down;
            } else if(downRight.x < TRESHOLD) {
                col = downRight;
            } else if(downLeft.x < TRESHOLD) {
                col = downLeft;
            } else if(left.x < TRESHOLD) {
                col = left;
            } else if(right.x < TRESHOLD) {
                col = right;
            }
        } else if(col.x <= STONE) {
            if(down.x < TRESHOLD) {
                col = down;
            } else if(downRight.x < TRESHOLD) {
                col = downRight;
            } else if(downLeft.x < TRESHOLD) {
                col = downLeft;
            }
        }

    }

    if(fragCoord.y < 5.0) {
        col = vec3(STATIC);
    }

    if(iResolution.y - fragCoord.y < 5.0) {
        col = vec3(VOID);
    }

    float d = distance(fragCoord, iMouse.xy);

    // BRUSH
    InitButtons();
    float selectedTile = texture(iChannel1, pix).x;
    if(d < 2.5 && (col.x < TRESHOLD || selectedTile < TRESHOLD) && !isInsideRect(iMouse.xy, buttons[0])) {
        // VOID STONE WATER
        col = vec3(selectedTile);
    }

    fragColor = vec4(col, 1.0);
}