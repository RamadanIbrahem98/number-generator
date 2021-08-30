const e = require("express");
const express = require("express");
const app = express();

const { addNewUser, getUser, getUserByEmail, updateUserPassword, deleteUser } = require('./queries');
// import { getUserByEmail as isDuplicate } from './queries';

const PORT = process.env.PORT || 3000;

app.use(express.json({ extended: false }));

app.get('/', (req, res, next) => {
  res.send('Hello World');
});

app.post('/signup', (req, res, next) => {
  const { fname, lname, email, password } = req.body;
  getUserByEmail(email).then(res => {
    if(!res) {
      addNewUser(fname, lname, email, password).then(user => {
        res.send(user);
      });
    } else {
      res.send('User Not Added');
    }
  });
});

app.delete('/user', (req, res, next) => {
  const {email, password} = req.body;
  deleteUser(email, password)
    .then(user => {
      if (user) {
        res.send('User Deleted');
      } else {
        res.send('User Not Deleted');
      }
    }).catch(err => {
      console.log(err);
      res.send('User Not Deleted');
    });
})

app.listen(PORT, () => {
  console.log(`Listening on port ${PORT}`);
})