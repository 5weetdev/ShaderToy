// TILES
#define STATIC 1.0
#define VOID  0.0
#define STONE 0.5
#define WATER 0.25

// UI
#define BUTTON_COUNT 4
#define BUTTON_SIZE 15.0
#define PADDING 10.0
#define CREATE_DEFAULT_BUTTON createRect(vec2(BUTTON_SIZE, BUTTON_SIZE), vec2(BUTTON_SIZE + PADDING, BUTTON_SIZE + PADDING))

struct Rect {
    vec2 size;
    vec2 position;
    mat2 transformationMatrix;
    vec3 color;
};

// BUTTONS
Rect buttons[BUTTON_COUNT];
Rect previewBrush;

mat3 rotation2D(float angle) {
    float cosTheta = cos(angle);
    float sinTheta = sin(angle);

    return mat3(cosTheta, -sinTheta, 0.0, sinTheta, cosTheta, 0.0, 0.0, 0.0, 1.0);
}

Rect createRect(vec2 size, vec2 position) {
    return Rect(size, position, mat2(1.0), vec3(1.0));
}

void rotateRect(inout Rect rectangle, float angle) {
    float cosAngle = cos(angle);
    float sinAngle = sin(angle);
    rectangle.transformationMatrix = mat2(cosAngle, -sinAngle, sinAngle, cosAngle);
}

vec2 transformVertex(Rect rectangle, vec2 vertex) {
    return rectangle.position + rectangle.transformationMatrix * (vertex * rectangle.size);
}

bool isInsideRect(vec2 point, Rect rectangle) {
    vec2 localPoint = (point - rectangle.position) * inverse(rectangle.transformationMatrix);

    return abs(localPoint.x) <= rectangle.size.x && abs(localPoint.y) <= rectangle.size.y;
}

bool isInsideBounds(vec2 point, vec2 minBounds, vec2 maxBounds) {
    return all(greaterThanEqual(point, minBounds)) && all(lessThanEqual(point, maxBounds));
}

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void InitButtons() {
    for(int i = 0; i < BUTTON_COUNT; i++) {
        buttons[i] = CREATE_DEFAULT_BUTTON;
        buttons[i].position.x += float(i - 1) * BUTTON_SIZE * 2.0;
    }

    buttons[1].color = vec3(VOID);
    buttons[2].color = vec3(STONE);
    buttons[3].color = vec3(0.0, 0.0, 1.0);
    buttons[0].color = vec3(0.1);
    buttons[0].size = vec2((BUTTON_SIZE * 3.0) + 5.0, BUTTON_SIZE + 5.0);
    buttons[0].position = vec2(BUTTON_SIZE * 3.0 + PADDING, BUTTON_SIZE + PADDING);

    previewBrush = createRect(vec2(10.0), vec2(0.0, 0.0));
}