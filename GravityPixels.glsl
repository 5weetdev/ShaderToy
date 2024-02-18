// Uncomment to enable
//#define ENABLE_GRAVITY_FOR_OTHER_POINTS
#define DELTA_TIME 100.0 // Decrease for accuracy
#define ITERATIONS 100   // Increase for accuracy
// Distance threshold to any spcae body
#define VOID_DISTANCE_TRESHOLD 100.0

// Space body structure
struct Body
{
    vec2 position;
    vec2 velocity;
    float mass;
};

// Define functions
vec2 calculateGravitationalForce(Body body1, Body body2);
vec2 applyForce(Body body, vec2 force, float deltaTime);

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    
    // Change that to move and zoom camera
    vec2 zoom = vec2(1.0);
    vec2 trans = vec2(0.0, 0.0);
    
    // Creates body in fragment coordinates
    Body Point1;
    Point1.position = vec2((fragCoord.x + trans.x) * zoom.x, (fragCoord.y + trans.y) * zoom.y);
    Point1.velocity = vec2(0.0, 0.0);
    Point1.mass = 1.0;
    
    // Create body on mouse position coordinates
    Body Point2;
    Point2.position = vec2(iMouse.x, iMouse.y);
    Point2.velocity = vec2(0.0, 0.0);
    Point2.mass = 10.0;

    // Static point
    Body Point3;
    Point3.position = vec2(iResolution.x * 0.25, iResolution.y * 0.25);
    Point3.velocity = vec2(0.0, 1.0); // Moves up
    Point3.mass = 10.0;
    
    // Moving point
    Body Point4;
    Point4.position = vec2(iResolution.x * 0.75, iResolution.y * 0.25);
    Point4.velocity = vec2(0.0, 0.0);
    Point4.mass = 10.0;

    for(int i = 0; i < ITERATIONS; i++){
        // point 1
        vec2 force2 = calculateGravitationalForce(Point1, Point2);
        vec2 force3 = calculateGravitationalForce(Point1, Point3);
        vec2 force4 = calculateGravitationalForce(Point1, Point4);

        Point1.velocity += applyForce(Point1, force2, DELTA_TIME);
        Point1.velocity += applyForce(Point1, force3, DELTA_TIME);
        Point1.velocity += applyForce(Point1, force4, DELTA_TIME);

#ifdef ENABLE_GRAVITY_FOR_OTHER_POINTS
        // point 2
        force2 = calculateGravitationalForce(Point2, Point1);
        force3 = calculateGravitationalForce(Point2, Point3);
        force4 = calculateGravitationalForce(Point2, Point4);

        Point2.velocity += applyForce(Point2, force2, DELTA_TIME);
        Point2.velocity += applyForce(Point2, force3, DELTA_TIME);
        Point2.velocity += applyForce(Point2, force4, DELTA_TIME);

        // point 3
        force2 = calculateGravitationalForce(Point3, Point2);
        force3 = calculateGravitationalForce(Point3, Point1);
        force4 = calculateGravitationalForce(Point3, Point4);

        Point3.velocity += applyForce(Point3, force2, DELTA_TIME);
        Point3.velocity += applyForce(Point3, force3, DELTA_TIME);
        Point3.velocity += applyForce(Point3, force4, DELTA_TIME);

        // point 4
        force2 = calculateGravitationalForce(Point4, Point2);
        force3 = calculateGravitationalForce(Point4, Point3);
        force4 = calculateGravitationalForce(Point4, Point1);

        Point4.velocity += applyForce(Point4, force2, DELTA_TIME);
        Point4.velocity += applyForce(Point4, force3, DELTA_TIME);
        Point4.velocity += applyForce(Point4, force4, DELTA_TIME);
#endif

        // Apply position
        Point1.position += Point1.velocity;
        Point2.position += Point2.velocity;
        Point3.position += Point3.velocity;
        Point4.position += Point4.velocity;
    }

    vec3 col = vec3(0.0, 0.0, 0.0);
    
    float dist2 = distance(Point1.position / iResolution.xy, Point2.position / iResolution.xy);
    float dist3 = distance(Point1.position / iResolution.xy, Point3.position / iResolution.xy);
    float dist4 = distance(Point1.position / iResolution.xy, Point4.position / iResolution.xy);

    // Color fragments based on distance 
    if (
        dist2 < VOID_DISTANCE_TRESHOLD &&
        dist3 < VOID_DISTANCE_TRESHOLD &&
        dist4 < VOID_DISTANCE_TRESHOLD)
    {
        //col += vec3(1.0) - vec3(dist2, dist3, dist4);
        if(dist2 < dist3 && dist2 < dist4)
        {
            col += vec3(dist2, 0.0, 0.0);
        }
        if(dist3 < dist2 && dist3 < dist4)
        {
            col += vec3(0.0, dist3, 0.0);
        }
        if(dist4 < dist3 && dist4 < dist2)
        {
            col += vec3(0.0, 0.0, dist3);
        }
    }

    // Output to screen
    fragColor = vec4(col,1.0);
}

// Calculate gravitational force between two bodies
vec2 calculateGravitationalForce(Body body1, Body body2) {
    const float G = 1.0; // Gravitational constant
    
    vec2 r = body2.position - body1.position; // Vector from body1 to body2
    float distanceSquared = dot(r, r); // Square of the distance between the bodies
    
    // Avoid division by zero
    if (distanceSquared < 0.0001) {
        return vec2(0.0); // Return zero force if the bodies are too close
    }
    
    float forceMagnitude = (G * body1.mass * body2.mass) / distanceSquared; // Magnitude of the force
    vec2 forceDirection = normalize(r); // Direction of the force
    
    vec2 force = forceDirection * forceMagnitude; // Calculate the force vector
    return force;
}

// Apply force to a body and update its velocity
vec2 applyForce(Body body, vec2 force, float deltaTime) {
    vec2 acceleration = force / body.mass; // Calculate acceleration using Newton's second law (F = ma)
    return acceleration * deltaTime;
}