const assert = require('assert');
const Websocket = require('ws');
const fs = require('fs')


const protocal = require('../protocal/protocal-core').default;


const hallServer = {
  port: 8303,
  hostname: '192.168.103.98',
}

const websocketUrl = `ws://${hallServer.hostname}:${hallServer.port}/ws`;


describe('大厅服务器', () => {
  describe('websocket api', () => {
    var websocket, sp;

    before(function(done) {
      websocket = socketHelper.openSocket(done);
    });

    after(function(done) {
      socketHelper.closeSocket(websocket, done);
    });

    it('protocal', (done) => {
       fs.readFile('./test/sproto.sproto', function (err, buff) {
        if (err) return console.error('error', err);

        var dataview = new DataView(array2arraybuffer(buff));
        var schema = new Array();
        for (var i = 0; i < dataview.byteLength; i++) {
            schema[i] = dataview.getUint8(i);
        }


           protocal.init(schema, websocket.send.bind(websocket), (callback) => {
               websocket.on('message', callback);
           });
        var s = {
          platform: 'mocha',
          game: 'test',
          token: '123456',
        };
           var d = protocal.send("login", s, (msg) => {
               console.log('login reply', msg);
           })

           protocal.on('refresh_card', (msg) => {
               console.log('refresh card: ', msg);
               done();
           })
       });

    });
  });
});

function arraybuffer2array(buffer) {
  var v = new DataView(buffer, 0);
  var a = new Array();
  for (var i = 0; i < v.byteLength; i++) {
      a[i] = v.getUint8(i);
  }
  return a;
}

function array2arraybuffer(array) {
    var b = new ArrayBuffer(array.length);
    var v = new DataView(b, 0);
    for (var i = 0; i < array.length; i++) {
        v.setUint8(i, array[i]);
    }
    return b;
}

function toArrayBuffer(buf) {
    var ab = new ArrayBuffer(buf.length);
    var view = new Uint8Array(ab);
    for (var i = 0; i < buf.length; ++i) {
        view[i] = buf[i];
    }
    return ab;
}



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
