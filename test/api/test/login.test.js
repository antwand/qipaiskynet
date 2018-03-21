const assert = require('assert');
const axios = require('axios'); // https://github.com/axios/axios

const loginServer = {
  port: 8203,
  hostname: '192.168.103.98',
}

const urls = {
  loginByPassword: `http://${loginServer.hostname}:${loginServer.port}/login`,
}

describe('登录服务器', () => {

  describe('http api', () => {

    it('/login 成功', function(){
      const data = {
        user: 'test',
        password: 'test',
        cmd: 'common_user_login',
      }
      return new Promise((resolve) =>
        axios.post(urls.loginByPassword, data).then(function(res) {
          assert.equal(200, res.status);
          // console.log(res.data);
          resolve();
        })
      );
    });

    it.skip('/login 失败', function(){

    });

    it.skip('/invalid_path', function(){

    });
  });
});
