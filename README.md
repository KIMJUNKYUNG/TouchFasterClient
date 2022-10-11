# TouchFasterClient

<h2> How to play </h2>
<img src="https://user-images.githubusercontent.com/52786004/194686146-2fd1a0ff-91dd-4fbe-a97a-254e1fe649a0.png" width="200" />

**TouchFasterClient is a simple game for ios**

After the game is started, It makes 10 circles that have numbers on the screen you can touch the circles in order, If you touch "10" then you are the winner of the game

<h2> Nickname System </h2>

<p>
  <img src="https://user-images.githubusercontent.com/52786004/194689266-c8cb35e2-1df7-4e9e-9229-40a95858acf5.png" width="200" />
  <img src="https://user-images.githubusercontent.com/52786004/194689278-d1bcc6c3-2d2a-4a29-8b02-94793c068c82.png" width="200" />
</p>

1. When you turn on the app first, you need to register your nickname for the high score System. When you have cleared the game, your score is saved with it. because of the high score system, TouchFaster can be played when the server is open
2. HighScores are saved in MongoDB Server with typed nickName

<h2> Single </h2>
<p float="left">
  <img src="https://user-images.githubusercontent.com/52786004/194689337-4be0a6f6-0908-43b8-a02f-bae5239a8b06.png" width="200" /> 
  <img src="https://user-images.githubusercontent.com/52786004/194689347-f4081787-e4b9-4b00-93f8-539ee59ed1d5.png" width="200" />
  <img src="https://user-images.githubusercontent.com/52786004/194686146-2fd1a0ff-91dd-4fbe-a97a-254e1fe649a0.png" width="200" />
</p>

When you play Single Game, You can play the game by yourself and can check for high scores

<h2> Multi </h2>
<p>
  <img src="https://user-images.githubusercontent.com/52786004/194689362-1a99ffa6-1dc6-44c7-9497-96fe7a57f43e.png" width="200" />
  <img src="https://user-images.githubusercontent.com/52786004/194689392-ee0c0146-7f88-40ec-81ef-e2e672134ef8.png" width="200" />
  <img src="https://user-images.githubusercontent.com/52786004/194689403-7fc6134e-48a6-4f54-af44-60ced6fe61b9.png" width="200" />
  <img src="https://user-images.githubusercontent.com/52786004/194689497-5c9f31f1-dae3-4025-9619-564e6435f00f.png" width="200" />
</p>

1. "+" Button : You can make the room for multi-play Game, When another user makes a room you can choose and join the room
2. HighScores Button : You can check HighScores in DB
3. Users Button : You can check the User list who logOn now

<h2> Room </h2>
<p>
  <img src="https://user-images.githubusercontent.com/52786004/194689447-cd83e53c-eac5-40a5-bfd4-96abd79a5457.png" width="200" />
  <img src="https://user-images.githubusercontent.com/52786004/194689459-225223bc-c2ad-48f0-9ce5-6078f7ae7e3a.png" width="200" />
  <img src="https://user-images.githubusercontent.com/52786004/194689930-0d4967d7-64ad-4054-af6a-c6b5c521b973.png" width="200" />
  <img src="https://user-images.githubusercontent.com/52786004/194689488-28eb3e6e-7cb9-47a8-9f37-d5fac9160fb2.png" width="200" />
</p>
 
1. The Left and right top of the profiles shows Users' nickname and ready condition. 
2. The left side is the room owner and the right side is the room client. If someone is ready for the game **READY Label** is changed to orange
3. After all of the players are ready, "**START"** button is shown on the Room Owner's screen
4. After started, 3secs of count down are shown and then the game is started
5. When someone finished earlier, the game ended
6. the winner's nickname and time record is shown. this record is saved to DB Server

<h2>Component</h2>

Client - Swift(IOS)

Server - NodeJS(socket.io) 

DB - MongoDB

<h2>Explanation</h2>
1. Client and Server are communicated with Socket.io
2. Room informations (for current room list) are saved to NodeJS Server
3. Room Conditions (for inner Room's condition, ex) Ready, NickName... ) are saved to NodeJS Server
4. HighScores are saved to MongoDB


