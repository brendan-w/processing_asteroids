/*
  Game Logic
*/

private int upTime = 0;
private int health = 100;
private int maxMass = 30;
private int massIncrement = 5;

private String message1 = "PREPARE TO DEFEND YOUR PLANET";
private String message2 = "press [SPACE] when ready";
private boolean barUp = false; //prevents accidental game restarts from in-game firing

private void showReady()
{
  if(spaceBar == false)
  {
    barUp = true;
  }
  else if((spaceBar == true) && barUp)
  {
    newGame();
  }
  
  fill(255);
  textSize(40);
  text(message1, width / 2, height / 2);
  textSize(14);
  text(message2, width / 2, (height / 2) + 40);
  noFill();
}

private void newGame()
{
  upTime = 0;
  health = 100;
  maxMass = 30;
  barUp = false;
  space = new Space();
}

private void endGame()
{
  int time = (int) (upTime / frameRate);
  message1 = "YOU LASTED " + time + " SECONDS";
  
  if(time < 100)
  {
    message2 = "actually TRY next time...";
  }
  else if(time < 200)
  {
    message2 = "you must hate planets...";
  }
  else
  {
    message2 = "good, but still no cigar...";
  }
  
  message2 += " press [SPACE] to try again";
  space = null;
}


private void checkLose()
{
  if((health <= 0) || (!space.player.alive))
  {
    endGame();
  }
}


private void make(int totalMass)
{
  if(totalMass + 30 <= maxMass)
  //if(spaceBar) //testing purposes only
  {
    maxMass += massIncrement;
    space.generate();
  }
}
