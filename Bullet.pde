

private class Bullet extends Mass
{
 
  public boolean alive = false;
  
  public Bullet()
  {
    super(5, 0, new PVector(0,0), new PVector(0,0), false);
  }
  
  private void begin(PVector pos, float angle)
  {
    position = pos.get();
    
    //accounts for ship rotation
    PVector offset = new PVector(0, -10);
    offset.rotate(angle);
    position.add(offset);
    
    velocity.set(0, -bulletSpeed);
    velocity.rotate(angle);
    alive = true;
  }
  
  private void frame()
  {
      checkAlive();
      run();
      stroke(playerColor);
      ellipse(getX(), getY(), 1, 1);
  }
  
  private void checkAlive()
  {
    if((position.x < 0) ||
       (position.x > width) ||
       (position.y < 0) ||
       (position.y > height))
       {
          alive = false; 
       }
  }
  
  public boolean checkCollision(Asteroid object)
  {
    
    if(distance(object).mag() < object.mass)
    {
      object.destruct(true);
      alive = false;
      return true;
    }
    else
    {
      return false;
    }
  }
}
