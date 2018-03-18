const _ = require('lodash');

const Sproto = require('./sproto');


let sessionId = 0;

class ProtocalCore {
    
    init(protocal, sender, receiver) {
        this.protocal = Sproto.createNew({ buf: protocal, sz: protocal.length });
        if (this.protocal === null) {
            console.log("failed to create sproto");
            return false;
        }

        this.protocal.host("package");
        this.packer = this.protocal.attach();
        this.messageHandlers = {}; // 服务器消息消息函数
        this.sender = sender;
        receiver(this.recv.bind(this));
        return true;
    }

    // 客户端发送的消息
    send(message, options, callback) {
        sessionId += 1;
        const packedMessage = this.packer(message, options, sessionId).buf;
        this.messageHandlers[`${sessionId}`] = callback;
        this.sender(arrayToArrayBuffer(packedMessage));
        return true;
    }


    // 监听服务端消息
    on(message, callback) {
        if (!_.isString(message)) return fasle;
        this.messageHandlers[`${message}`] = callback;
        return true;
    }

    recv(buffer) {
        let buf = arrayBufferToArray(toArrayBuffer(buffer));
        const handleMessage = (sessionId, message) => {
            const messageHandler = this.messageHandlers[`${sessionId}`];

            // debug
            // console.info('receive message: ', sessionId, message);

            if (_.isFunction(messageHandler)) {
                messageHandler(message);

                if (_.isInteger(sessionId)) {
                    this.messageHandlers = _.omit(this.messageHandlers, `${sessionId}`)
                }
            }
        }
        this.protocal.dispatch({buf, sz: buf.length}, handleMessage, handleMessage)
    }
}

function arrayBufferToArray(buffer) {
    var v = new DataView(buffer, 0);
    var a = new Array();
    for (var i = 0; i < v.byteLength; i++) {
        a[i] = v.getUint8(i);
    }
    return a;
}

function arrayToArrayBuffer(array) {
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




export default new ProtocalCore();
