
private class Planet extends Mass
{
  
  private final int maxRadius = 100;
  private final int minRadius = 40;
  
  public int radius = maxRadius;
  private int currentHealth = 100;
  
  public Planet(Space mgr, int ms, PVector pos)
  {
    super(ms, 0, pos, new PVector(0,0), false);
  }
  
  public void frame()
  {
    //draw the planet
    int targetSize = (int) map(health, 0, 100, minRadius, maxRadius);
    if(radius > targetSize){radius--;}
    currentHealth = (int) map(radius, minRadius, maxRadius, 0, 100);
    
    stroke(planetColor);
    ellipse(position.x, position.y, radius, radius);
    textSize(20);
    fill(planetColor);
    text(currentHealth + "%", position.x, position.y);
    noFill();
    
  }
  
  public boolean checkCollision(Asteroid object)
  {
    if(distance(object).mag() < (radius + object.mass))
    {
      //run collider
      health -= (int) object.mass / 2;
      object.destruct(false);
      return true;
    }
    else
    {
      return false;
    }
  }
}
