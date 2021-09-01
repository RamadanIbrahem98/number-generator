const express = require("express");
const app = express();

const cors = require("cors");
app.use(cors());

const { addNewUser, getUser } = require('./queries');

const PORT = process.env.PORT || 3000;

app.use(express.json({ extended: true }));

// app.use(function(req, res, next) {
//   res.header("Content-Type", 'application/json');
//   res.header("Access-Control-Allow-Origin", "*");
//   res.header("Access-Control-Allow-Methods", "POST, OPTIONS");
//   next();
// });

app.post('/login', (req, res, next) => {
  const { email, password } = req.body;
  console.log({ email, password });
  getUser(email, password).then(user => {
    if(user != null) {
      res.status(200).send({message: 'OK', payload: user.rows[0]});
    } else {
      res.status(401).send({message: 'Email and Password Compination are wrong'});
    }
  })
})

app.post('/signup', (req, res, next) => {
  const { fname, lname, email, password } = req.body;

  console.log({ fname, lname, email, password });

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