# P Controller for Picking Up and Dropping  

This repo gives the G-code to pick up the object and move to the desired position before dropping.  

What makes this code interesting is that this code is programmed to   
**complete the task even if the object is moving on the ground with the "low" speed.**  

**Preparation:** The robot lifts to the top.  
**Step 1.** Obtain object's position + velocity + transfer to reference.  
**Step 2.** [P controller loop] Track the object's position (x, y).  
**Step 3.** getting down to the object, assume that the time getting down is negligible for reference velocity (dx, dy).  
**Step 4.** Activate suction.  
**Step 5.** Pick the object to the top position.  
**Step 6.** Move the object to the drop position (x, y) while maintaining at the highest altitude.  
**Step 7.** Get down to the drop point (x, y, z).  
**Step 8.** Release the object and reset the robot.
