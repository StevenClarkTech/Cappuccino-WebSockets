var express = require('express');
var socket = require('socket.io');
// App setup

var app = express();
var port = 8001;
var server = app.listen(port, function(){
  console.log('listen to requests on port: ', port);
});

// Static files
// this points localhost:8000 -> game_client/index.html
app.use(express.static('game_client'));

// Socket setup
var io = socket(server);

// JJSON for game_state
var game_state_fake = {
  board: "[Ac, Th, Qs]",
  players_sat: [{
              seat: 1,
              name: "Johnny",
              chips: 1000
          },
         {
              seat: 2,
              name: "Bob",
              chips: 1337
          }
        ],
  hero_sat: '0',
  players_with_cards: "[1, 2]",
  bigBlind: "3", //this is the seat of the BB
  smallBlind: "2",
  button: "1"
};






io.on('connection', function(socket){
  // we've successfully made a connection from socket to the server
  console.log('made socket connection from the server!', socket.id);
  game_state_fake.hero_sat = 0;
  // we should emit the current game_state
  socket.emit('message', game_state_fake);

  socket.on('sitDown', function(player){
      game_state_fake.hero_sat = player.seat;

        var seatAlreadyTaken = false;

      game_state_fake.players_sat.forEach(function(item){

        if (item.seat == player.seat) {
          console.log('already sat: item ', item.name);
          item.name = 'hero_override';
          item.chips = 1;
          seatAlreadyTaken = true;
        }
      });
      if (seatAlreadyTaken == false) {
        game_state_fake.players_sat.push({seat: player.seat, name: 'hero'+player.seat, chips: 2000   });
      }

      // if the above forloop didnt do shit, add new object to players_sat
      io.sockets.emit('message', game_state_fake);

  });

  socket.on('clear', function(data){

      console.log('should clear players sat');

      game_state_fake.hero_sat = 0;
      game_state_fake.players_sat = [];
      io.sockets.emit('message', game_state_fake);

  });

 /* pseudocode for an example of an action
  ----------------------------------------------------------

  socket.on('fold', function(data){

    GS.currentGameState.players_with_cards.removeObject(data.player);
    socket.emit('game_state', GS.currentGameState);

  });
*/


});
