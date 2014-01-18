/*
  Base class for a moving or gravitational object
*/

public class Mass
{
  
  public int mass;
  public PVector position;
  public PVector velocity;
  private PVector force; //doubles as acceleration (when divided by mass)
  private float friction;
  private boolean snapZero; //snaps velocity to zero when within tolerance
  
  //settings
  private final int timeScale = 40;
  private final int gravConst = 80;
  private final float velTol = 1; //velocity at which it is considered 0 (had drifting problems)
  
  public Mass(int ms, float frict, PVector pos, PVector vel, boolean snap)
  {
    mass = ms;
    friction = frict;
    position = pos;
    velocity = vel;
    snapZero = snap;
    force = new PVector(0,0);
  }
  
  public void clearForce()
  {
    force.x = 0;
    force.y = 0;
  }
  
  public void addForce(Mass object)
  {
    //get distance between objects
    PVector gap = distance(object);
    //calculate force compenents
    float gravForce = gravConst * object.mass * this.mass / gap.magSq();
    gap.normalize();
    gap.mult(gravForce);
    force.add(gap);
  }
  
  public void addForce(float fx, float fy)
  {
    this.force.x += fx;
    this.force.y += fy;
  }
  
  public void run()
  {
    if(velocity.mag() > velTol)
    {
      //add friction force
      PVector frict = velocity.get();
      frict.normalize();
      frict.mult(-1);
      frict.mult(friction);
      force.add(frict);
    }
    else
    {
      if(snapZero){velocity.set(0,0);}
    }
    //compute acceleration and velocity
    float t = timeScale / frameRate;
    velocity.x += force.x / mass * t;
    velocity.y += force.y / mass * t;
    //compute position
    position.x += velocity.x * t;
    position.y += velocity.y * t;
  }
  
  //creates elastic collision with another mass
  public void collide(Mass object)
  {
    //this object
    PVector thisVel = velocity.get();
    thisVel.mult(mass - object.mass);
    PVector part = object.velocity.get();
    part.mult(2 * object.mass);
    thisVel.add(part);
    thisVel.div(mass + object.mass);
    
    //other object
    PVector otherVel = object.velocity.get();
    otherVel.mult(object.mass - mass);
    part = velocity.get();
    part.mult(2 * mass);
    otherVel.add(part);
    otherVel.div(mass + object.mass);
    
    //update velocities
    velocity = thisVel;
    object.velocity = otherVel;
  }
  
  public PVector distance(Mass object)
  {
    PVector gap = object.position.get();
    gap.sub(position);
    return gap;
  }
  
  public int getX(){return Math.round(position.x);}
  public int getY(){return Math.round(position.y);}
  
}
