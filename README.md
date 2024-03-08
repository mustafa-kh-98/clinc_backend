# clinic

## More Commands

 Export dart_frog
 
```shell
export PATH="$PATH":"$HOME/.pub-cache/bin"
```
 Open server
```shell
dart_frog dev
```
 Open server with custom host and port
```shell
dart_frog dev --hostname 192.168.2.6 --port 8080q22 WR4
```
 Create new route
```shell
dart_frog new route /api/v1/user/get_users
```
 Create new route
```shell
dart_frog new route "api/v1/ray/rays"
```
 Create new dynamic route
```shell
dart_frog new route "api/v1/user/[id]"
```

 Create new middleware
```shell
dart_frog new middleware "/api/v1/ray/ray_middleware"
```
 Build 
```shell
dart run build_runner build --delete-conflicting-outputs
```
 Start MogoDb
```shell
 sudo systemctl start  mongod
```
 Start FireWall
```shell
 sudo ufw status
```

