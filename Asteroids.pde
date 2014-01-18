/*
  Core
*/

import java.awt.Point;
import java.util.ArrayList;

//physics handler
private Space space; //game is running when (space != null)

//keys
public boolean up = false;
public boolean down = false;
public boolean left = false;
public boolean right = false;
public boolean spaceBar = false;

//settings
public final color spaceColor = color(0,0,0);
public final color playerColor = color(0,255,90);
public final color planetColor = color(0,155,255);
public final color asteroidColor = color(255,255,255);
public final color warningColor = color(200,0,0);

public PShape playerGraphics;
public PShape warningGraphics;

public final int astMass = 30;
public final float minMass = 16;
public final float astFrict = 0.075; //forces orbit to gradually decay
public final float playFrict = 0.65;
public final int bulletSpeed = 14;
public final int maxBullets = 10;
public final int fireRate = 2; //every N frames

void setup()
{
  size(900, 900, P2D);
  frameRate(30);
  strokeWeight(2);
  textAlign(CENTER, CENTER);
  noFill();
  ellipseMode(RADIUS);
  buildGraphics();
}

void draw()
{
  background(spaceColor);
  
  if(space != null) //if game is running
  {
    space.frame();
    upTime++;
    checkLose();
  }
  else
  {
    showReady();
  }
}

private void buildGraphics()
{
  stroke(playerColor);
  playerGraphics = createShape();
  playerGraphics.beginShape();
  playerGraphics.vertex(0, -10);
  playerGraphics.vertex(-5,10);
  playerGraphics.vertex(5,10);
  playerGraphics.endShape(CLOSE);
  
  stroke(warningColor);
  warningGraphics = createShape();
  warningGraphics.beginShape();
  warningGraphics.vertex(-10,10);
  warningGraphics.vertex(0,0);
  warningGraphics.vertex(10,10);
  warningGraphics.endShape();
}

void keyPressed()
{
  if(key == CODED)
  {
    if(keyCode == UP){up = true;}
    else if(keyCode == DOWN){down = true;}
    else if(keyCode == LEFT){left = true;}
    else if(keyCode == RIGHT){right = true;}
  }
  else
  {
    if(key == ' '){spaceBar = true;}
    else if(key == 'w'){up = true;}
    else if(key == 's'){down = true;}
    else if(key == 'a'){left = true;}
    else if(key == 'd'){right = true;}
  }
}

void keyReleased()
{
  if(key == CODED)
  {
    if(keyCode == UP){up = false;}
    else if(keyCode == DOWN){down = false;}
    else if(keyCode == LEFT){left = false;}
    else if(keyCode == RIGHT){right = false;}
  }
  else
  {
    if(key == ' '){spaceBar = false;}
    else if(key == 'w'){up = false;}
    else if(key == 's'){down = false;}
    else if(key == 'a'){left = false;}
    else if(key == 'd'){right = false;}
  }
}
