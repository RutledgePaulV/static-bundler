## static bundler

A shell script that generates the necessary package.json and index.js 
in order to bundle a static site as an electron app for offline access
for people who maybe aren't as familiar with things like http-server. 
It also creates a release.sh script that can be used to create distributions
for all the supported targets of electron-packager.