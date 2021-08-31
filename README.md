# number-generator

This Branch is for the authentication and authorization of users

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
