const assert = require('assert');
const Websocket = require('ws');

const hallServer = {
  port: 8303,
  hostname: 'localhost',
}

const websocketUrl = `ws://${hallServer.hostname}:${hallServer.port}/ws`;


const socketHelper = {
  openSocket: (done) => {
    const websocket = new Websocket(websocketUrl);
     websocket.on('open', function () {
       console.log('open...');
       done()
    });

    websocket.on('disconnect', function() {
      console.log('disconnected...');
    })
    return websocket;
  },

  closeSocket: (websocket, done) => {
    if(websocket.readyState !== 1) {
        console.log('disconnecting...');
        websocket.disconnect();
    } else {
        console.log('no connection to break...');
    }
    done();
  },
}


describe('大厅服务器', () => {

  describe('websocket api', () => {
    var websocket;
    before(function(done) {
      websocket = socketHelper.openSocket(done);
    });

    after(function(done) {
      socketHelper.closeSocket(websocket, done);
    });

    it('发送文本消息，并接受返回结果', (done) => {
      const msg = 'hello skynet';
      websocket.send(msg);
      websocket.on('message', (response) => {
        assert.equal(response, 'reply: '+msg);
        done();
      });
    });

    

  });
});
