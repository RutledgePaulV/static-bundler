## static bundler

A docker image that bundles static sites into apps for each operating system.

### Usage
```bash
# from the directory containing your static site (starts at index.html)
docker run -v $(pwd):/home/user/application/public -e USER_ID=$(id -u) rutledgepaulv/static-bundler

# you'll find your executables divided up by operating system inside the ./distributions directory
```

### Why
Sometimes you want to distribute a prototype of a site to people who don't know
how to serve up a site locally. Particularly useful when it's desirable that they
can access the site offline.


### How
The docker image uses electron along with some really basic bootstrap code to start
a server and then uses a &lt;webview&gt; tag to make the app frame just proxy through
to that server.

Since electron-packager requires windows or wine in order to build the executables for windows
this docker image installs wine as well.


### License

This project is licensed under [MIT license](http://opensource.org/licenses/MIT).