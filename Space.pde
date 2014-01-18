/*
  Physics & Graphics
*/

private class Space
{

  public Player player;
  private Bullet[] bullets;
  private Planet planet;
  public ArrayList<Asteroid> asteroids;
  public ArrayList<Mass> gravWells;
  
  public Space()
  {
    player = new Player(this, 1, playFrict, new PVector(width / 2, (height / 2) - 50));
    bullets = new Bullet[maxBullets];
    for(int i = 0; i < bullets.length; i++)
    {
      bullets[i] = new Bullet();
    }
    planet = new Planet(this, 150, new PVector(width / 2, height / 2));
    asteroids = new ArrayList<Asteroid>();
    gravWells = new ArrayList<Mass>();
    gravWells.add(planet);
  }
  
  //compute and draw objects
  public void frame()
  {
    //println("calc");
    calc(); //calculate collisions
    //println("run");
    if(player.alive){run();} //update position and draw
  }
  
  private void calc()
  {
    //Player with Planet/////////////////////////
    player.checkCollision(planet);
    
    //Asteroids loop/////////////////////////////
    for(int i = 0; i < asteroids.size(); i++)
    {
      Asteroid current = asteroids.get(i);
      boolean deleted = false;
      //with player------------------------------
      player.checkCollision(current);
      //with bullets----------------------------
      for(int b = 0; b < bullets.length; b++)
      {
        if(bullets[b].alive && !deleted)
        {
          deleted = bullets[b].checkCollision(current);
        }
      }
      //with planet------------------------------
      if(!deleted)
      {
        deleted = planet.checkCollision(current);
      }
      //with other asteroid---------------------
      int k = i + 1;
      while(!deleted && (k < asteroids.size()))
      {
        Asteroid other = asteroids.get(k);
        deleted = current.checkCollision(other);
        k++;
      }
       
      if(deleted) {i--;} //backtrack, this asteroid has been deleted
    }
  }
  
  private void run()
  {
    int totalMass = 0;
    //run & draw each asteroid///////////////////////
    for(int i = 0; i < asteroids.size(); i++)
    {
      Asteroid current = asteroids.get(i);
      current.frame();
      totalMass += current.mass;
    }
    planet.frame(); //run & draw the planet
    player.frame(); //run & draw the player
    
    //Run and draw each Bullet///////////////////////
    Bullet nextBullet = null;
    for(int b = 0; b < bullets.length; b++)
    {
      if(bullets[b].alive)
      {
        bullets[b].frame();
      }
      else
      {
        if(nextBullet == null){nextBullet = bullets[b];}
      }
    }
    
    if(spaceBar && (frameCount % fireRate == 0) && (nextBullet != null))
    {
      //activate the next bullet
      nextBullet.begin(player.position, player.rotPosition);
    }
    
    make(totalMass); //launch new asteroids if the game says it's ok
  }
  
  //generates a new asteroid
  public void generate()
  {
    float angle = 0;
    float vary = 400;
    PVector pos = new PVector(0,0);
    
    do
    {
      float r = random(4);
      if(0 < r && r < 1)
      {
        pos.set(width / 2, -astMass);
        pos.x += random(vary) - (vary / 2);
        angle = 0;
      }
      else if(1 < r && r < 2)
      {
        pos.set(width + astMass, height / 2);
        pos.y += random(vary) - (vary / 2);
        angle = HALF_PI;
      }
      else if(2 < r && r < 3)
      {
        pos.set(width / 2, height + astMass);
        pos.x += random(vary) - (vary / 2);
        angle = PI;
      }
      else if(3 < r && r < 4)
      {
        pos.set(-astMass, height / 2);
        pos.y += random(vary) - (vary / 2);
        angle = HALF_PI * 3;
      }
    }while(!safeSpawn(pos));

    float rot = HALF_PI;
    PVector vel = new PVector(0, 1);
    vel.mult(random(2) + 3.5);
    vel.rotate(angle - rot);
    
    new Asteroid(this, astMass, astFrict, pos, vel);
  }
  
  private boolean safeSpawn(PVector pos)
  {
    boolean safe = true;
    int i = 0;
    while(safe && (i < asteroids.size()))
    {
      PVector gap = asteroids.get(i).position.get();
      gap.sub(pos);
      if(gap.mag() < (astMass + 2)){safe = false;}
      i++;
    }
    return safe;
  }
  
}
