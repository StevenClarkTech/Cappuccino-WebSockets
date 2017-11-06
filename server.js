var express = require('express');
var socket = require('socket.io');
// App setup

var app = express();
var server = app.listen(8000, function(){
  console.log('listen to requests on port 8000!');
});

// Static files
// this points localhost:8000 -> game_client/index.html
app.use(express.static('game_client'));

// Socket setup
var io = socket(server);

// JJSON for game_state
var game_state_fake = {
  board: "[Ac, Th, Qs]",
  players_sat: [
        {
            name:  'John1',
            seat:   '1',
        },
        {
            name:  'Jake2',
            seat:   '2',
        }
  ],
  players_with_cards: "[seat1, seat2]",
  bigBlind: "seat3",
  smallBlind: "seat2",
  button: "seat1"
};

io.on('connection', function(socket){
  // we've successfully made a connection from socket to the server
  console.log('made socket connection from the server!', socket.id);

  // we should emit the current game_state
  socket.emit('message', game_state_fake);


 /* pseudocode for an example of an action
  ----------------------------------------------------------

  socket.on('fold', function(data){

    GS.currentGameState.players_with_cards.removeObject(data.player);
    socket.emit('game_state', GS.currentGameState);

  });
*/


});
