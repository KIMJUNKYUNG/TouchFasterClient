# TouchFasterClient

<h2> How to play </h2>

![Simulator Screen Shot - iPhone 14 - 2022-10-08 at 11 32 28](https://user-images.githubusercontent.com/52786004/194686146-2fd1a0ff-91dd-4fbe-a97a-254e1fe649a0.png)

**TouchFasterClient is a simple game for ios**

After the game is started, It makes 10 circles that have numbers on the screen you can touch the circles in order, If you touch "10" then you are the winner of the game

<h2> Nickname System </h2>

![simulator_screenshot_2FEA5BA9-9F00-4339-89C2-1095CDF7B748](/Users/kimjunkyung/Library/Application Support/typora-user-images/simulator_screenshot_2FEA5BA9-9F00-4339-89C2-1095CDF7B748.png)

When you turn on the app first, you need to register your nickname for the high score System. When you have cleared the game, your score is saved with it. because of the high score system, TouchFaster can be played when the server is open

![simulator_screenshot_56E83F90-0411-481B-BEBA-1E831E2FE23D](/Users/kimjunkyung/Library/Application Support/typora-user-images/simulator_screenshot_56E83F90-0411-481B-BEBA-1E831E2FE23D.png)

HighScores are saved in MongoDB Server

<h2> Single </h2>

![Simulator Screen Shot - iPhone 14 - 2022-10-08 at 11.36.18](/Users/kimjunkyung/Desktop/Simulator Screen Shot - iPhone 14 - 2022-10-08 at 11.36.18.png)

![simulator_screenshot_E5484B42-80B6-437C-B004-6C695FAFF883](/Users/kimjunkyung/Library/Application Support/typora-user-images/simulator_screenshot_E5484B42-80B6-437C-B004-6C695FAFF883.png)

When you play Single Game, You can play the game by yourself and can check for high scores

<h2> Multi </h2>

![simulator_screenshot_9A014C2D-57B6-4F7F-8B03-3E3516CF7635](/Users/kimjunkyung/Library/Application Support/typora-user-images/simulator_screenshot_9A014C2D-57B6-4F7F-8B03-3E3516CF7635.png)

<h3>"+" Button </h3>

1. You can make the room for multi-play Game![simulator_screenshot_7324B89D-7CBB-41A7-BD1F-EF57204BD718](/Users/kimjunkyung/Library/Application Support/typora-user-images/simulator_screenshot_7324B89D-7CBB-41A7-BD1F-EF57204BD718.png)![simulator_screenshot_05B40F0D-0E4E-4735-BDC3-6D7029D9391D](/Users/kimjunkyung/Library/Application Support/typora-user-images/simulator_screenshot_05B40F0D-0E4E-4735-BDC3-6D7029D9391D.png)

   *When another user makes a room you can choose the room and join*

   

2. The Left and right top of the profiles shows Users' nickname and ready condition. the left side is the room owner and the right side is the room client. If someone is ready for the game **READY Label** is changed to orange<img src="/Users/kimjunkyung/Library/Application Support/typora-user-images/simulator_screenshot_5CABA9C0-DF5E-4BA9-9A6D-8AED8C132C63.png" alt="simulator_screenshot_5CABA9C0-DF5E-4BA9-9A6D-8AED8C132C63" style="zoom:80%;" />

   

3. After all of the players are ready, "**START"** button is shown in Room Owner's view![simulator_screenshot_6AE04636-2A30-493C-835F-B90D7559D097](/Users/kimjunkyung/Library/Application Support/typora-user-images/simulator_screenshot_6AE04636-2A30-493C-835F-B90D7559D097.png)

   

4. After started, 3secs of count down are shown and then the game is started![simulator_screenshot_21B8D930-17C9-4CF9-960B-AD0701147AD9](/Users/kimjunkyung/Library/Application Support/typora-user-images/simulator_screenshot_21B8D930-17C9-4CF9-960B-AD0701147AD9.png)

5. when someone finished earlier, the game ended and shows the winner's nickname and time record. this record also saved to DB Server![simulator_screenshot_5B9237FD-9F48-4755-9757-E8CAF0AEA3D6](/Users/kimjunkyung/Library/Application Support/typora-user-images/simulator_screenshot_5B9237FD-9F48-4755-9757-E8CAF0AEA3D6.png)

<h3>"HighScore" Button : You can check HighScores in DB</h3>

<h3>"Users" Button : You can check the User list who logOn now</h3>



![simulator_screenshot_815ADA0B-A776-4600-8FAE-D0E1EAD5118C](/Users/kimjunkyung/Library/Application Support/typora-user-images/simulator_screenshot_815ADA0B-A776-4600-8FAE-D0E1EAD5118C.png)

<h2>Component</h2>

Client - Swift(IOS)

Server - NodeJS(socket.io) 

DB - MongoDB

1. Client and Server are communicated with Socket.io
2. Room information for showing room list client can join it is saved to NodeJS
3. Room Condition for showing the inner Room's condition like ready or nickName Information is saved to NodeJS
4. HighScore is saved to MongoDB

