int numSteps = 1000;
float[][] positions = new float[3][2];
float[][] velocities = new float[3][2];
float[] masses = {10.0, 10.0, 10.0};
float G = 50.0; 
ArrayList<float[]>[] trails = new ArrayList[3];
boolean isPaused = false; 
void setup() {
  size(800, 800);
  frameRate(10);

  
  positions[0] = new float[] {300, 400};
  positions[1] = new float[] {500, 400};
  positions[2] = new float[] {400, 500};

  velocities[0] = new float[] {0, 2.0};
  velocities[1] = new float[] {0, -2.0};
  velocities[2] = new float[] {-2.0, 0};

  
  for (int i = 0; i < 3; i++) {
    trails[i] = new ArrayList<float[]>();
    trails[i].add(positions[i].clone());
  }
}

void draw() {
  background(0);

  
  float centerX = 0;
  float centerY = 0;
  for (int i = 0; i < 3; i++) {
    centerX += positions[i][0];
    centerY += positions[i][1];
  }
  centerX /= 3;
  centerY /= 3;

  translate(width / 2 - centerX, height / 2 - centerY);

  if (!isPaused) {
  
    for (int step = 0; step < 5; step++) { 
      updateSimulation();
    }
  }

  
  strokeWeight(2);
  for (int i = 0; i < 3; i++) {
    noFill();
    stroke(i == 0 ? color(255, 0, 0) : i == 1 ? color(0, 255, 0) : color(0, 0, 255));
    beginShape();
    for (float[] point : trails[i]) {
      vertex(point[0], point[1]);
    }
    endShape();
  }

  
  noStroke();
  fill(255, 0, 0);
  ellipse(positions[0][0], positions[0][1], 10, 10);
  fill(0, 255, 0);
  ellipse(positions[1][0], positions[1][1], 10, 10);
  fill(0, 0, 255);
  ellipse(positions[2][0], positions[2][1], 10, 10);
}

void updateSimulation() {
  float[][] accelerations = new float[3][2];

  for (int i = 0; i < 3; i++) {
    accelerations[i][0] = 0;
    accelerations[i][1] = 0;

    for (int j = 0; j < 3; j++) {
      if (i != j) {
        float dx = positions[j][0] - positions[i][0];
        float dy = positions[j][1] - positions[i][1];
        float distance = sqrt(dx * dx + dy * dy);
        if (distance > 5) { 
          float force = G * masses[j] / (distance * distance);

          accelerations[i][0] += force * dx / distance;
          accelerations[i][1] += force * dy / distance;
        }
      }
    }
  }

  for (int i = 0; i < 3; i++) {
    velocities[i][0] += accelerations[i][0];
    velocities[i][1] += accelerations[i][1];

    positions[i][0] += velocities[i][0] * 0.5; 
    positions[i][1] += velocities[i][1] * 0.5; 

    
    trails[i].add(positions[i].clone());
    if (trails[i].size() > 500000) {
      trails[i].remove(0); 
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    isPaused = !isPaused; 
  }
}
