# number-generator

## Alert

**There is only one commit done after deadline, which is the build android apk**
you can find it under **build\app\outputs\flutter-apk\app-release.apk**

Of course you can dismiss this commit and evaluate based on the previous commits only

## Edits

Merged Backend Branch with main in order not to have to clones on your local machine.

## App Status

- [x] design the API
- [x] design app views
- [x] add sign up/in input validations
- [x] add sign up/in and logout basic flow
- [ ] add save generated numbers to a file logic
- [x] add find a number validation
- [x] add find a number logic
- [ ] refactor the app
- [x] deploy the database online

## Set up the environment

1 - install the Dependencies

```sh
npm install
```

2 - add the environment variables

- create a file named **.env** in project root directory
- add the following variables with your values

**DB_USERNAME**, **DB_PASSWORD**, **DB_NAME**, **DB_HOST** ,**DB_PORT**

3 - run the application

### 

```sh
npm start
```

### Endpoints

```sh
curl -X POST -H "Content-Type: application/json" \
    -d '{"fname": "first name", "lname": "last name", "email": "email@example.com", "password": "your password"}' \
    localhost/signup
```

```sh
curl -X POST -H "Content-Type: application/json" \
    -d '{"email": "email@example.com", "password": "your password"}' \
    localhost/login
```
