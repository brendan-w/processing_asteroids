Asteroids - with Processing
Written by Brendan Whitfield

This game is a derivative of the game Asteroids. It works on the same principals as the original (shooting & destroying asteroids), but with the twist of gravity. The planet in the middle of the screen generates a gravitational pull on the asteroids, bringing them into elliptical orbits. The player's objective (in addition to not getting hit), is to protect the planet from collisions.

Because gravity naturally produces stable orbits, a slight frictional force has been added to every asteroid. Over time, this causes the orbits to decay, resulting in collisions with the planet. Asteroids may also collide with one another. These collisions are perfectly elastic, and are influenced by the mass of each asteroid. Asteroids that are bounced or flung off screen are denoted by a red arrow that follows the object.

Internally, every moving object is an extension of the "Mass" class. This class contains all of the vectors and functions neccessary for handling the game's physics. The "Space" class is the primary manager for all objects on screen. It maintains references, runs, and checks for collisions on every object. Asteroid with Asteroid collisions are checked using a complete graph algorithm that prevents any redundant checks from being performed.

When a game is started, a new "Space" object is created, and draw() begins calling it's frame() function. On every frame (after collisions and drawing) the "Space" class computes the total mass present on the playing field. This total mass is then used to determine if the game should release a new asteroid. If it is below a certain limit, a new asteroid is made, and the limit is raised slightly. This creates an increase in difficulty over time for the player.