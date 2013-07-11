ArrayList<Boid> boids;

void setup(){
  size(500,500, P3D);
  background(255);
  setupBoids(300);
}

void draw(){
   background(255);
   drawBoids();
   moveBoidsToNewPosition();
}

void setupBoids(int num){
  boids = new ArrayList<Boid>();
  for(int i = 0; i < num; i++){
    boids.add(new Boid(random(0,500), random(0,500), 6, 6));
  }
}

void drawBoids(){
  for(int i = 0; i < boids.size(); i++){
    boids.get(i).draw();
  }
}

void moveBoidsToNewPosition(){
  PVector v1 = new PVector(0,0); 
  PVector v2 = new PVector(0,0); 
  PVector v3 = new PVector(0,0);
  PVector v4 = new PVector(0,0);
  //println(v1);
  Boid b;
  for(int i = 0; i < boids.size(); i++){
    b = boids.get(i);
    v1 = b.rule1();
    v2 = b.rule2();
    v3 = b.rule3();
    v4 = tendToPlace(b);
    
    b.velocity = PVector.add(b.velocity, v1);
    b.velocity = PVector.add(b.velocity, v2);
    b.velocity = PVector.add(b.velocity, v3);
    b.velocity = PVector.add(b.velocity, v4);
    limitVelocity(b);
    b.position = PVector.add(b.position, b.velocity);
    
    //println(b.position);
  }
}

class Boid{
  PVector position;
  PVector velocity;
  
  Boid(float posx, float posy, float vx, float vy){
    position = new PVector(posx, posy);
    velocity = new PVector(vx, vy);
  }
  
  void draw(){
    ellipse(position.x, position.y, 2, 2);
  }
  
  PVector rule1(){
    PVector pcj;
    pcj = getAverageBoidPosition();
    for(int i = 0; i < boids.size(); i++){
      Boid b = boids.get(i);
      if( b != this ){
        pcj = PVector.add(pcj, b.position);
      }
      
    }
    pcj = PVector.div(pcj, boids.size()-1);
    pcj = PVector.sub(pcj, this.position);
    return PVector.div(pcj, 100);
  }
  
  PVector rule2(){
    PVector c;
    c = new PVector(0,0);
    for(int i = 0; i < boids.size(); i++){
      Boid b = boids.get(i);
      
      if( b != this ){
        PVector v = PVector.sub(b.position, position);
        if( v.mag() < 10 ){
          PVector temp = PVector.sub(b.position, position);
          c = PVector.sub(c, temp);
        }
      }
      
    }
    return c;
  }
  
  PVector rule3(){
    PVector pcj;
    pcj = getAverageBoidVelocity();
    for(int i = 0; i < boids.size(); i++){
      Boid b = boids.get(i);
      
      if( b != this ){
        pcj = PVector.add(pcj, b.velocity);
      }
      
    }
    pcj = PVector.div(pcj, boids.size()-1);
    pcj = PVector.sub(pcj, velocity);
    return PVector.div(pcj, 8);
  }
}

PVector getAverageBoidPosition(){
  PVector avg = new PVector(0,0);
  for(int i = 0; i < boids.size(); i++){
    Boid b = boids.get(i);
    avg = PVector.add(avg, b.position);
  }
  return PVector.div(avg, boids.size()-1);
}

PVector getAverageBoidVelocity(){
  PVector avg = new PVector(0,0);
  for(int i = 0; i < boids.size(); i++){
    avg = PVector.add(avg, boids.get(i).velocity);
  }
  return PVector.div(avg, boids.size());
}

void limitVelocity(Boid b){
  int vlim = 7;
 
  if( b.velocity.mag() > vlim){
    b.velocity = PVector.div(b.velocity, b.velocity.mag());
    b.velocity = PVector.mult(b.velocity, vlim);
  } 
}

PVector tendToPlace(Boid b){
  PVector place = new PVector(mouseX, mouseY);
  place = PVector.sub(place, b.position);
  return PVector.div(place, 100);
}


  
