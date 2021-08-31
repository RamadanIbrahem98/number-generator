const express = require("express");
const app = express();

const { addNewUser, getUser } = require('./queries');

const PORT = process.env.PORT || 3000;

app.use(express.json({ extended: true }));

app.use(function(req, res, next) {
  res.header("Content-Type", 'application/json');
  res.header("Access-Control-Allow-Origin", "*");
  next();
});

app.post('/login', (req, res, next) => {
  const { email, password } = req.body;

  getUser(email, password).then(doesExist => {
    if(doesExist) {
      res.status(200).send({message: 'OK'});
    } else {
      res.status(401).send({message: 'Email and Password Compination are wrong'});
    }
  })
})

app.post('/signup', (req, res, next) => {
  const { fname, lname, email, password } = req.body;

  addNewUser(fname, lname, email, password).then(user => {
    if(user != null) {
      console.log(user);
      res.status(200).send({message: 'Ok', payload: user});
    } else {
      res.status(401).jsonp({message: "Email Already Exists"});
    }
  }).catch(err => console.error(err));
});

app.use('*', (req, res, next) => {
  res.status(404).jsonp({message: 'invalid endpoint'});
});

app.listen(PORT, () => {
  console.log(`Listening on port ${PORT}`);
});