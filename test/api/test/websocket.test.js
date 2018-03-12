const assert = require('assert');
const Websocket = require('ws');
const fs = require('fs')

const Sproto = require('./sproto.js');

const hallServer = {
  port: 8303,
  hostname: 'localhost',
}

const websocketUrl = `ws://${hallServer.hostname}:${hallServer.port}/ws`;

var isLittleEndian = (function() {
  var buffer = new ArrayBuffer(2);
  new DataView(buffer).setInt16(0, 256, true /* littleEndian */);
  // Int16Array uses the platform's endianness.
  return new Int16Array(buffer)[0] === 256;
})();


function arraybuffer2array(buffer) {
  var v = new DataView(buffer, 0);
  var a = new Array();
  if (isLittleEndian){
    v.setInt16(1, 32767);
  }
  for (var i = 0; i < v.byteLength; i++) {
      a[i] = v.getUint8(i);
  }
  return a;
}



function swapBytes(buf, size) {
    var bytes = new Uint8Array(buf);
    var len = bytes.length;
    var holder;

    if (size == 'WORD') {
        // 16 bit
        for (var i = 0; i<len; i+=2) {
            holder = bytes[i];
            bytes[i] = bytes[i+1];
            bytes[i+1] = holder;
        }
    } else if (size == 'DWORD') {
        // 32 bit
        for (var i = 0; i<len; i+=4) {
            holder = bytes[i];
            bytes[i] = bytes[i+3];
            bytes[i+3] = holder;
            holder = bytes[i+1];
            bytes[i+1] = bytes[i+2];
            bytes[i+2] = holder;
        }
    }
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




describe('大厅服务器', () => {
  describe('websocket api', () => {
    var websocket;
    var sp;
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
    it.only('发送Sproto消息，并接受返回结果', (done) => {
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

        var s = {};
        s.platform = "mocha";
        s.game = "test";
        //alert(GetQueryString("code"));
        s.token = '123456';
        sp.host("package");
        var packer = sp.attach();
        var p = packer("login", s, 1).buf;
        var d = array2arraybuffer(p);
        console.log('login', d);
        websocket.send(d);
        websocket.on('message', (buff) => {

              var d = arraybuffer2array(toArrayBuffer(buff));
              function handle_rsp(session, data)
              {
                console.log('buff',JSON.stringify(data));
                done();
              }
              sp.dispatch({buf: d, sz: d.length}, handle_rsp, handle_rsp);
          });
      })
    });

  });
});
