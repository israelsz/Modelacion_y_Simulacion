// Integrantes: Christofer Allup - Israel Arias - Christian Mendez
Multitud multitud;
int timeStart = millis();
int yPosRandom;

//Definicion de constantes
float A = 25.0;
float B = 0.08;
float k = 750;
float k2 = 3000;
float v0 = 5;
float ti = 0.5;

// Setup de la simulacion
void setup() {
  //Se crea el lienzo
  size(700, 500);
  //Personas
  multitud = new Multitud();
}

//Se dibuja el pasillo
void draw() {
  background(0);
  line(0, 0, 600, 216); //pared 1
  line(0, 500, 600, 284); // pared 2
  fill(#e72c2c);
  circle(200, 200, 50); //Pilar grande
  fill(#e72c2c);
  circle(380, 280, 30); //Pilar pequeño

  //Se dibujan las personas y se agregan al multitud cada 0.15 segundos
  if (millis() > timeStart + 150){
    yPosRandom = int(random(15, 486));
    multitud.addBoid(new Boid(5, yPosRandom));
    timeStart = millis();
  }
  multitud.run();
}

// Agregar personas con el mouse
void mousePressed() {
  multitud.addBoid(new Boid(mouseX,mouseY));
}

//Clase multitud que contiene a las personas
class Multitud {
  //ArrayList<Boid> que contiene a las personas de la multitud
  ArrayList<Boid> boids;

  Multitud() {
    boids = new ArrayList<Boid>();
  }

  void run() {
    for (Boid b : boids) {
      b.run(boids);
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }

}

//Clase Boid que representa a una persona
class Boid {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;  // radio de la persona
  float maxforce;   // fuerza maxima
  float maxspeed;   // velocidad maxima

  Boid(float x, float y) {
    r = 15.0/2;
    maxspeed = 2;
    maxforce = 0.03;
    acceleration = new PVector(0, 0);
    position = new PVector(x, y);

    float xangle = 0;
    float yangle = 0;
    velocity = new PVector(0, 0);

    //Centro del pasillo
    if(y > 216 && y < 284){
      yangle = 0;
      xangle = 1;
    }
    //Seccion superior del pasillo
    if(y < 216){
      xangle = 1;
      yangle = atan((284-y)/(600-x));
    }
    //Seccion inferior del pasillo
    if(y > 284){
      xangle = 1;
      yangle = atan((284-y)/(600-x));
    }

    velocity = new PVector(xangle, yangle);
    velocity.mult(10); // velocidad inicial
  }

  void run(ArrayList<Boid> boids) {
    multitud(boids);
    update();
    handleCollisions(boids);
    render();
  }

  // Metodo para actualizar la posicion
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    position.add(velocity);
    acceleration.mult(0);
  }

  // Metodo para aplicar una fuerza
  void applyForce(PVector force) {
    acceleration.add(force);
  }

  // Se establecen el comportamiento de las fuerzas que interactuan con las personas
  void multitud(ArrayList<Boid> boids) {
    PVector rep = repulsion(boids);   // Separacion
    PVector align = alignment(boids);      // Alineacion
    PVector fricc = friccion(boids);   // Friccion
    PVector murallaSup = murallaSup();   // Muralla superior
    PVector murallaInf = murallaInf();   // Muralla inferior
    PVector pilarGrande = pilarGrande();   // Pilar grande
    PVector pilarPequenio = pilarPequenio();   // Pilar pequeño
    PVector vel = velocidad();  // Velocidad

    // Se agregan las fuerzas al vector de aceleracion
    applyForce(rep);
    applyForce(align);
    applyForce(fricc);
    applyForce(murallaSup);
    applyForce(murallaInf);
    applyForce(pilarGrande);
    applyForce(pilarPequenio);
    applyForce(vel);
  }

  // Metodo para calcular la direccion a la que dirigirse para salir del pasillo
  // dependiendo de su posicion en el pasillo
  PVector velocidad() {
    PVector steer = new PVector(0, 0, 0);

    float xangle = 0;
    float yangle = 0;

    //Centro del pasillo
    if(position.y > 216 && position.y < 284){
      yangle = 0;
      xangle = 1;
    }
    //Superior del pasillo
    if(position.y < 216){
      xangle = 1;
      yangle = atan((284-position.y)/(600-position.x));
    }
    //Inferior del pasillo
    if(position.y > 284){
      xangle = 1;
      yangle = atan((284-position.y)/(600-position.x));
    }

    PVector direccion = new PVector(xangle, yangle);

    direccion.mult(v0);
    direccion.sub(velocity);
    direccion.div(ti);

    steer.add(direccion);
    return steer;
  }

  // Se dibujan las personas
  void render() {

    fill(#ffffff);
    stroke(255);
    pushMatrix();
    translate(position.x, position.y);

    //Dibujar circulos
    int sides = 50;
    float angle = 360 / sides;
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y);
    }
    endShape(CLOSE);
    popMatrix();
  }

  // Metodo para establecer la interaccion de la persona con el pilar grnade
  PVector pilarGrande() {
    PVector steer = new PVector(0, 0, 0);

    //Vectores para cada una de las fuerzas
    PVector pilarGRep = new PVector(-200, 200);
    PVector pilarGAlign = new PVector(-200, 200);
    PVector pilarGFricc = new PVector(200, 200);
    pilarGAlign.normalize();
    pilarGRep.normalize();
    pilarGFricc.normalize();

    //Se calcula la distancia entre la persona y el pilar grande
    float d = sqrt(pow(200-position.y,2)+pow(200-position.x,2));

      if ((d > 0) && (d < r+25) && (position.x < 225)) {
        float velocidad_rel = velocity.dot(pilarGFricc);

        //Si se encuentra en la parte superior del pilar lo rodea por arriba
        if(position.y < 190){
          pilarGAlign.mult(2*k*(r-25-d));
          pilarGRep.mult(A*exp((r-25-d)/B));
          pilarGFricc.mult(k2*(r-25-d)*velocidad_rel);
        }

        //Si se encuentra en la parte inferior del pilar lo rodea por abajo
        else{
          pilarGAlign.mult(2*k*(r+25-d));
          pilarGRep.mult(A*exp((r+25-d)/B));
          pilarGFricc.mult(k2*(r+25-d)*velocidad_rel);
        }
        // Se agregan las fuerzas al vector de aceleracion
        steer.add(pilarGAlign);
        steer.add(pilarGRep);
        steer.add(pilarGFricc);
      }
    return steer;
  }

  // Metodo para establecer la interaccion de la persona con el pilar pequeño
  PVector pilarPequenio() {
    PVector steer = new PVector(0, 0, 0);

    //Vectores para cada una de las fuerzas
    PVector pilarPRep = new PVector(-380, 280);
    PVector pilarPAlign = new PVector(-380, 280);
    PVector pilarPFricc = new PVector(380, 280);
    pilarPAlign.normalize();
    pilarPRep.normalize();
    pilarPFricc.normalize();

    //Se calcula la distancia entre la persona y el pilar pequeño
    float d = sqrt(pow(380-position.x,2)+pow(280-position.y,2));

      if ((d > 0) && (d < r+15) && (position.x < 380)) {
        float velocidad_rel = velocity.dot(pilarPFricc);

        //Si se encuentra en la parte superior del pilar lo rodea por arriba
        if(position.y < 280){
          pilarPAlign.mult(2*k*(r-15-d));
          pilarPRep.mult(A*exp((r-15-d)/B));
          pilarPFricc.mult(k2*(r-15-d)*velocidad_rel);
        }
        //Si se encuentra en la parte inferior del pilar lo rodea por abajo
        else{
          pilarPAlign.mult(2*k*(r+15-d));
          pilarPRep.mult(A*exp((r+15-d)/B));
          pilarPFricc.mult(k2*(r+15-d)*velocidad_rel);
        }
        // Se agregan las fuerzas al vector de aceleracion
        steer.add(pilarPAlign);
        steer.add(pilarPRep);
        steer.add(pilarPFricc);
      }
    return steer;
  }

  // Metodo para establecer la interaccion de la persona con la muralla superior
  PVector murallaSup() {
    PVector steer = new PVector(0, 0, 0);

    //Vectores para cada una de las fuerzas
    PVector murallaRep = new PVector(-600, 216);
    PVector murallaAlign = new PVector(-600, 216);
    PVector murallaFricc = new PVector(600, 216);
    murallaAlign.normalize();
    murallaRep.normalize();
    murallaFricc.normalize();

    //Ecuacion distancia entre punto a segmento
    float d = abs((600-0)*(0-position.y)-(0-position.x)*(216-0))/sqrt(pow(600,2)+pow(216,2));

      if ((d > 0) && (d <= r) && (position.x < 600)) {
        float velocidad_rel = velocity.dot(murallaFricc);

        murallaAlign.mult(2*k*(r-d));  //  Alineacion
        murallaRep.mult(A*exp((r-d)/B));  //  Fuerza de repulsion
        murallaFricc.mult(k2*(r-d)*velocidad_rel);  //  Fuerza de friccion
        // Se agregan las fuerzas al vector de aceleracion
        steer.add(murallaAlign);
        steer.add(murallaRep);
        steer.add(murallaFricc);
      }
    return steer;
  }

  // Metodo para establecer la interaccion de la persona con la muralla inferior
  PVector murallaInf() {
    PVector steer = new PVector(0, 0, 0);
    //Vectores para cada una de las fuerzas
    PVector murallaRep = new PVector(-(600-0), 284-500);
    PVector murallaAlign = new PVector(-(600-0), 284-500);
    PVector murallaFricc = new PVector(600-0, 284-500);
    murallaAlign.normalize();
    murallaRep.normalize();
    murallaFricc.normalize();

    //Ecuacion distancia entre punto a segmento
    float d = abs((600-0)*(500-position.y)-(0-position.x)*(284-500))/sqrt(pow(600,2)+pow(284-500,2));

      if ((d > 0) && (d <= r) && (position.x < 600)) {
        float velocidad_rel = velocity.dot(murallaFricc);

        murallaAlign.mult(2*k*(r-d));  //  Fuerza de Alineacion
        murallaRep.mult(A*exp((r-d)/B));  //  Fuerza de repulsion
        murallaFricc.mult(k2*(r-d)*velocidad_rel);  //  Fuerza de friccion
        // Se agregan las fuerzas al vector de aceleracion
        steer.add(murallaAlign);
        steer.add(murallaRep);
        steer.add(murallaFricc);
      }
    return steer;
  }

  // Metodo para calcular y aplicar la fuerza de repulsion entre personas
  PVector repulsion(ArrayList<Boid> boids) {
    float desiredseparation = 6*r;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // Por cada persona en la multitud, se calcula si esta lo suficientemente cerca para repeler
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < desiredseparation)) {
        // Calcular vector de direccion apuntando lejos del vecino
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.mult(A*exp((r*2-d)/B)); //  Fuerza de repulsion
        steer.add(diff);
        count++;
      }
    }
    // Promedio de las fuerzas
    if (count > 0) {
      steer.div((float)count);
    }
    return steer;
  }

  // Metodo para calcular la alineacion entre personas
  PVector alignment(ArrayList<Boid> boids) {
    PVector steer = new PVector(0, 0, 0);
    // Por cada persona en la multitud, se calcula si esta lo suficientemente cerca para modificar su alineacion
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d <= r*2)) {
        // Calcular vector de direccion apuntando lejos del vecino
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.mult(2*k*(r*2-d)); //  Alineacion
        steer.add(diff);
      }
    }
    return steer;
  }

  // Metodo para calcular y aplicar la fuerza de friccion entre personas
  PVector friccion(ArrayList<Boid> boids) {
    PVector steer = new PVector(0, 0, 0);

    // Por cada persona en la multitud, se calcula si esta lo suficientemente cerca para friccionar
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);

      if ((d > 0) && (d <= r*2)) {
        // Calcular vector de direccion apuntando lejos del vecino
        PVector diff = PVector.sub(position, other.position);
        float velocidad_rel = velocity.sub(other.velocity).dot(diff);
        diff.normalize().rotate(HALF_PI); //  Vector perpendicular a la direccion de la persona
        diff.mult(k2*(r*2-d)*velocidad_rel);  //  Fuerza de friccion
        steer.add(diff);
      }
    }
    return steer;
  }

  void handleCollisions(ArrayList<Boid> boids) {
  float minDistance = r * 2;
  float pilarGrandeRadius = 25.0; // Radio del pilar grande
  float pilarPequenioRadius = 15.0; // Radio del pilar pequeño
  PVector pilarGrandeCenter = new PVector(200, 200); // Posicion del pilar grande
  PVector pilarPequenioCenter = new PVector(380, 280); // Posicion del pilar pequeño

  for (Boid other : boids) {
    if (other != this) {
      float d = PVector.dist(position, other.position);
      if (d < minDistance) {
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.mult(minDistance - d);
        position.add(diff);
      }
    }
  }

  // Verificar y evitar la superposicion con el pilar grande
  PVector diffToPilarGrande = PVector.sub(position, pilarGrandeCenter);
  float distanceToPilarGrande = diffToPilarGrande.mag();
  if (distanceToPilarGrande < r + pilarGrandeRadius) {
    // Calcular vector de direccion para evitar la colision con el pilar grande
    diffToPilarGrande.normalize();
    diffToPilarGrande.mult((r + pilarGrandeRadius) - distanceToPilarGrande);
    position.add(diffToPilarGrande);
  }

  // Verificar y evitar la superposicion con el pilar pequeño
  PVector diffToPilarPequenio = PVector.sub(position, pilarPequenioCenter);
  float distanceToPilarPequenio = diffToPilarPequenio.mag();
  if (distanceToPilarPequenio < r + pilarPequenioRadius) {
    // Calcular vector de direccion para evitar la colision con el pilar pequeño
    diffToPilarPequenio.normalize();
    diffToPilarPequenio.mult((r + pilarPequenioRadius) - distanceToPilarPequenio);
    position.add(diffToPilarPequenio);
  }
}
}
