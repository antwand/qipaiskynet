const assert = require('assert');
const io = require('socket.io-client');

const hallServer = {
  port: 8303,
  hostname: 'localhost',
}

const websocketUrl = `ws://${hallServer.hostname}:${hallServer.port}`;

describe('大厅服务器', () => {

  var socket;

  beforeEach(function(done) {
    // Setup
    socket = io.connect(websocketUrl, { transports: ['websocket'], path: '/ws' });
     socket.on('connect', function() {
        console.log('worked...');
        socket.send('hello');
        done();
     });
     socket.on('disconnect', function() {
        console.log('disconnected...');
     })
  });

   afterEach(function(done) {
       // Cleanup
       if(socket.connected) {
           console.log('disconnecting...');
           socket.disconnect();
       } else {
           console.log('no connection to break...');
       }
       done();
   });

  describe('socket api', () => {
    it.only('/sproto 协议', function(done){
      const data = {
        user: 'test',
        password: 'test',
        cmd: 'common_user_login',
      }
      socket.send('hello skynet', (data) => {
        console.log('long: ', data);
        done()
      })
      console.log('websocket', WebSocket)
      assert.ok(true);
    });

  });
});
