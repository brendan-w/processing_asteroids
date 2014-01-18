
private class Player extends Mass
{
  
  private boolean alive = true;
  public float rotPosition;
  
  //settings
  private final int maxVel = 10;
  private final float rotSpeed = 0.15;
  
  public Player(Space mgr, int ms, float frict, PVector pos)
  {
    super(ms, frict, pos, new PVector(0,0), true);
    
  }
  
  public void frame()
  {
    if(alive)
    {
      //calculate rotary position
      if(right) {rotPosition += rotSpeed;}
      if(left) {rotPosition -= rotSpeed;}
      rotPosition = rotPosition % TWO_PI;
    
      //player input force
      clearForce();
      if(up)    {addForce((float) Math.sin(rotPosition), (float) -Math.cos(rotPosition));}
      if(down)  {addForce((float) -Math.sin(rotPosition), (float) Math.cos(rotPosition));}
    
      //clamp velocity
      if(velocity.mag() > maxVel){velocity.setMag(maxVel);}
    
      //compute new position
      run();
    
      //wrap the player around the screen
      if(position.x < 0){position.x = width;}
      else if(position.x > width){position.x = 0;}
      if(position.y < 0){position.y = height;}
      else if(position.y > height){position.y = 0;}
    
      //draw the player
      pushMatrix();
        translate(getX(), getY());
        rotate(rotPosition);
        shape(playerGraphics);
      popMatrix();
    }
  }
  
  public void checkCollision(Asteroid object)
  {
    if(distance(object).mag() < (object.mass + 5))
    {
      alive = false;
    }
  }
  
  public boolean checkCollision(Planet object)
  {
    return false;
  }
  
  
}
