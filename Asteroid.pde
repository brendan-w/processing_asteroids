private class Asteroid extends Mass
{
  
  //variables
  private Space space;
  private PShape graphics;
  private float rotPosition;
  private float rotSpeed;
  
  public Asteroid(Space mgr, int ms, float frict, PVector pos, PVector vel)
  {
    super(ms, frict, pos, vel, false);
    space = mgr;
    space.asteroids.add(this); //asteroids add themselves upon creation
    rotSpeed = map(random(1), 0, 1, -0.1, 0.1);
    
    stroke(asteroidColor);
    graphics = createShape();
    graphics.beginShape();
    int count = mass/2;
    for(int i = 0; i < count; i++)
    {
      PVector vert = new PVector(-1,0);
      vert.rotate(TWO_PI/count*i);
      float r = random(1);
      r = r*r*r; //makes asteroids rounder
      vert.mult(map(r, 0, 1, mass, mass/2));
      graphics.vertex((int) vert.x, (int) vert.y);
    }
    graphics.endShape(CLOSE);
  }
  
  public void frame()
  { 
    //recalculate all force on this object
    clearForce();
    for(int i = 0; i < space.gravWells.size(); i++)
    {
      addForce(space.gravWells.get(i));
    }
    
    //compute new position
    run();
    
    if(onScreen()) //draw asteroid graphic
    {
      rotPosition += rotSpeed;
      rotPosition = rotPosition % TWO_PI;
    
      //draw object
      pushMatrix();
        translate(getX(), getY());
        rotate(rotPosition);
        shape(graphics);
      popMatrix();
    }
    else //draw the warning arrow
    {
      pushMatrix();
        PVector center = new PVector(width / 2, height / 2);
        
        translate(center.x, center.y);
        center.sub(position);
        center.normalize();
        center.mult(-400);
        //println(center);
        translate(center.x, center.y);
        rotate((center.heading() + HALF_PI) % TWO_PI);
        
        shape(warningGraphics);
      popMatrix();
    }
  }
  
  public boolean checkCollision(Asteroid object)
  {
    if(distance(object).mag() < (mass + object.mass))
    {
      collide(object);
      return false;
      //destroys/splits asteroids on contact, but makes it too hard
      /*
      destruct(true);
      object.destruct(true);
      return true;
      */
    }
    else
    {
      return false;
    }
  }
  
  public void destruct(boolean children)
  {
    //launch child asteroids if necessary
    space.asteroids.remove(this);
    //create two child asteroids
    if((mass > minMass) && children)
    {
      int newMass = (int)(mass / 2);
      
      PVector offset = velocity.get();
      offset.normalize();
      offset.mult(newMass + 2);
      PVector pos1 = position.get();
      PVector pos2 = position.get();
      offset.rotate(-HALF_PI);
      pos1.add(offset);
      offset.rotate(PI);
      pos2.add(offset);
      
      PVector vel1 = velocity.get();
      PVector vel2 = velocity.get();
      vel1.rotate(-0.05);
      vel2.rotate(0.05);
      
      new Asteroid(space, newMass, astFrict, pos1, vel1);
      new Asteroid(space, newMass, astFrict, pos2, vel2);
    }
  }
  
  private boolean onScreen()
  {
    int x = getX();
    int y = getY();
    if((x <= -mass) || (x >= width + mass) || (y <= -mass) || (y >= height + mass))
    {
      return false;
    }
    else
    {
      return true;
    }
  }
}
