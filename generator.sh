#!/bin/bash


function create_package_json() {
cat << "EOF" > ./package.json
{
  "name": "app",
  "version": "0.0.1",
  "main": "index.js",
  "scripts": {
    "start": "electron ."
  },
  "license": "MIT",
  "devDependencies": {
    "electron-packager": "^8.4.0",
    "electron-prebuilt": "^0.36.10"
  },
  "dependencies": {
    "ecstatic": "^2.1.0",
    "express": "^4.14.0",
    "http": "0.0.0"
  }
}
EOF
}

function create_electron_shell() {
cat << "EOF" > ./index.js
'use strict';
const http = require('http');
const express = require('express');
const ecstatic = require('ecstatic');
const electron = require('electron');
const BrowserWindow = electron.BrowserWindow;
electron.app.on('ready', function() {
    const app = express();
    app.use(ecstatic({root: __dirname + '/public'}));
    const server = http.createServer(app);
    server.listen(0, "127.0.0.1", function () {
        const port = server.address().port;
        const host = server.address().address;
        const markup = `<html><head><script>console.log("Page Loaded!");</script></head>
                            <body style="margin: 0;"><webview style="height: 100%; width:100%;" 
                             src="http://${host}:${port}" disablewebsecurity></webview></body></html>`;
        let mainWindow = new BrowserWindow({fullscreen: true});
        mainWindow.loadURL(`data:text/html,${markup}`);
        mainWindow.on('closed', function () {
            mainWindow = null;
        });
    });
});
electron.app.on('window-all-closed', electron.app.quit);
EOF
}


function create_release_script() {
cat << "EOF" > /home/user/release.sh
#!/bin/bash
USER_ID=${USER_ID}
echo "Running process with UID : $USER_ID"
useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
export HOME=/home/user
chown -R user:user /home/user
exec /usr/local/bin/gosu user /bin/bash -c 'rm -rf public/distributions && mkdir -p public/distributions && electron-packager . app --out public/distributions --all'
EOF
chmod +x /home/user/release.sh
}

create_package_json
create_electron_shell
create_release_script

