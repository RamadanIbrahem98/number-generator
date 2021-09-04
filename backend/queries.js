require("dotenv").config();
const { Pool } = require("pg");
const bcrypt = require('bcrypt');

const connectionString = process.env.CONECTING_STRING

const pool = new Pool({
  connectionString,
});

// const pool = new Pool({
//   user: process.env.DB_USERNAME,
//   password: process.env.DB_PASSWORD,
//   database: process.env.DB_NAME,
//   host: process.env.DB_HOST,
//   port: process.env.DB_PORT,

// });

const createUsersTable = `
CREATE TABLE IF NOT EXISTS "Users" (
  "id" SERIAL,
  "fname" VARCHAR(50) NOT NULL,
  "lname" VARCHAR(50) NOT NULL,
  "email" VARCHAR(150),
  "password" VARCHAR(150) NOT NULL,
  PRIMARY KEY ("email")
);`;

pool.query(createUsersTable)
  .then(res => {
    return res.rows[0];
  })
  .catch(err => {
    return err;
  });

const addNewUser = (fname, lname, email, password) => {
  return bcrypt.hash(password, 10).then(hash => {
        const insertQuery = 'INSERT INTO "Users"(fname, lname, email, password) VALUES($1, $2, $3, $4) RETURNING *';
        const values = [fname, lname, email, hash];
        return pool.query(insertQuery, values).then(res => {
          console.log(`AddNewUser res is, ${res[1]}`);
          return res;
        }).catch(err => console.log(err));
      }).then(res => {
        return res.rows[0];
      }).catch(err => {console.log(`$48 {err}`);});
  }

const getUserByEmail = email => {
  const query = 'SELECT * FROM "Users" WHERE email = $1'
  const values = [email];
  return pool.query(query, values).then(res => {
      return res;
  }).catch(err => console.error(err));
};

const getUser = (email, password) => {
  return getUserByEmail(email).then(user => {
    if(user.rows[0]) {
      return user;
    } else {
      return null;
    }
  }).then(user => {
    if (user == null) {
      return null;
    } else {
    if (bcrypt.compareSync(password,user.rows[0]["password"])) {
      return user;
    }
    return null;
    }
  }).then(result => {
    return result;
  });
}

module.exports = {
  addNewUser,
  getUser
};