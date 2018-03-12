const assert = require('assert');
const Websocket = require('ws');
const fs = require('fs')

const hallServer = {
  port: 8303,
  hostname: 'localhost',
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

    it('发送Sproto消息，并接受返回结果', (done) => {
      const Sproto = require('./sproto.js');
      fs.readFile('./test/a', function (err, buff) {
        if (err) return console.error('error', err);

        var dataview = new DataView(array2arraybuffer(buff));
        var schema = new Array();
        for (var i = 0; i < dataview.byteLength; i++) {
            schema[i] = dataview.getUint8(i);
        }
        sp = Sproto.createNew({buf:schema, sz:schema.length});
        if (sp == null) {
            console.log("failed to create sproto");
        }

        var s = {
          platform: 'mocha',
          game: 'test',
          token: '123456',
        };

        sp.host("package");
        var packer = sp.attach();
        var p = packer("login", s, 1).buf;
        var d = array2arraybuffer(p);

        websocket.send(d);
        websocket.on('message', (buff) => {
          var d = arraybuffer2array(toArrayBuffer(buff));

          function handle_rsp(session, data)
          {
            console.log('返回结果', data);
            done();
          }
          sp.dispatch({buf: d, sz: d.length}, handle_rsp, handle_rsp);
        });
      })
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
