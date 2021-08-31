const express = require("express");
const app = express();

const { addNewUser, getUser } = require('./queries');

const PORT = process.env.PORT || 3000;

app.use(express.json({ extended: true }));

app.post('/login', (req, res, next) => {
  const { email, password } = req.body;

  getUser(email, password).then(doesExist => {
    if(doesExist) {
      res.send({status: 200, message: 'OK'});
    } else {
      res.send({status: 401, message: 'Email and Password Compination are wrong'});
    }
  })
})

app.post('/signup', (req, res, next) => {
  const { fname, lname, email, password } = req.body;

  addNewUser(fname, lname, email, password).then(user => {
    if(user != null) {
      console.log(user);
      res.send({status: 200, message: 'Ok', payload: user});
    } else {
      res.send({status: 401, message: "Email Already Exists"});
    }
  }).catch(err => console.error(err));
});

app.get('/', (req, res, next) => {
  res.send({status: 404, message: 'invalid endpoint'});
});

app.listen(PORT, () => {
  console.log(`Listening on port ${PORT}`);
});