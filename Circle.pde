class Circle{

float x, y;
float diameter;
boolean on = false;

void begin(float xpos, float ypos){
  x = xpos;
  y = ypos;
  on = true;
  diameter = 1;
}

void grow(){
  if(on == true){
    diameter+=0.5;
    if(x > 500){
      on = false;
    }
  }    
}

void display(){
  noFill();
  strokeWeight(4);
  stroke(color(x,y,diameter), 153);
  ellipse(x,y,diameter,diameter); 
}

}
