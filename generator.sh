#!/bin/bash


function create_package_json() {
cat << "EOF" > ./package.json
{
  "name": "prototype",
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
cat << "EOF" > ./release.sh
#!/bin/bash
npm install
rm -rf dist
mkdir -p dist
electron-packager . app --out dist --all
EOF
chmod +x ./release.sh
}

create_package_json
create_electron_shell
create_release_script

