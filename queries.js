require("dotenv").config();
const { Pool } = require("pg");
const bcrypt = require('bcrypt');
const { createHash } = require("crypto");

const pool = new Pool({
  user: process.env.DB_USERNAME,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
});

const createUsersTable = `
CREATE TABLE IF NOT EXISTS "Users" (
  "id" SERIAL,
  "fname" VARCHAR(50) NOT NULL,
  "lname" VARCHAR(50) NOT NULL,
  "email" VARCHAR(150) NOT NULL UNIQUE,
  "password" VARCHAR(150) NOT NULL,
  PRIMARY KEY ("id")
);`;

const updateUserPasswordQuery = `
UPDATE "Users"
SET "password" = $1,
WHERE email = $2
RETURNING *
`

pool.query(createUsersTable)
  .then(res => {
    pool.end();
    return res.rows[0];
  })
  .catch(err => {
    throw new err;
  });


const createHash = (salt = 10, password) => {
  const salt = bcrypt.genSaltSync(salt);
  const hash = bcrypt.hashSync(password, salt);
  return hash;
}

const addNewUser = (fname, lname, email, password) => {
  const hash = createHash(password=password);
  const insertQuery = 'INSERT INTO "Users"(fname, lname, email, password) VALUES($1, $2, $3, $4) RETURNING *';
  const values = [fname, lname, email, hash];

  pool.query(insertQuery, values)
    .then(res => {
      return res.rows[0]
    })
    .catch(err => {
      throw new err;
    });
};

const getUserByEmail = email => {
  const query = 'SELECT * FROM "Users" WHERE email = $1'
  const values = [email];
  pool.query(query, values)
    .then(res => {
      return res.rows[0];
    })
    .catch(err => {
      throw new err;
    });
};

const getUser = (email, password) => {
  const user = getUserByEmail(email);
  if (bcrypt.compareSync(password,user["password"])) {
    return true;
  }
  return false;
}

const updateUserPassword = (email, oldpassword, newPassword) => {
  const user = getUserByEmail(email);
  if (bcrypt.compareSync(oldpassword,user["password"])) {
    const newHash = createHash(10, newPassword);
    pool.query(updateUserPasswordQuery, [newHash, email])
      .then(res => {
        return res.rows[0];
      })
      .catch(err => {
        throw new err;
      });
  }
  return false;
}

const deleteUserByEmail = email => {
  const query = 'DELETE FROM "Users" WHERE email = $1'
  const values = [email];
  pool.query(query, values)
    .then(res => {
      return res.rows[0];
    })
    .catch(err => {
      throw new err;
    });
}

const deleteUser = (email, password) => {
  const user = getUserByEmail(email);
  if (bcrypt.compareSync(password,user["password"])) {
    deleteUserByEmail(user["id"]);
  }
}

module.exports = {
  addNewUser,
  getUser,
  updateUserPassword,
  deleteUser,
};