require("dotenv").config();
const { Pool } = require("pg");
const bcrypt = require('bcrypt');

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
    return res.rows[0];
  })
  .catch(err => {
    return err;
  });

const addNewUser = (fname, lname, email, password) => {
  bcrypt.genSalt(10, (err, salt) => {
    bcrypt.hash(password, salt, (err, hash) => {
      const insertQuery = 'INSERT INTO "Users"(fname, lname, email, password) VALUES($1, $2, $3, $4) RETURNING *';
      const values = [fname, lname, email, hash];

      return pool.query(insertQuery, values)
        .then(res => {
          console.log(res.rows[0]);
          return res.rows[0]
        })
        .catch(err => {
          return err;
        });
      });
  });
  return new Promise.resolve();
};

const getUserByEmail = email => {
  const query = 'SELECT * FROM "Users" WHERE email = $1'
  const values = [email];
  return pool.query(query, values)
    .then(res => {
      return res.rows[0];
    })
    .catch(err => {
      return err;
    });
};

const getUser = (email, password) => {
  getUserByEmail(email)
  .then(user => {
    if (bcrypt.compareSync(password,user["password"])) {
      return true;
    }
    return false;
  });
}

const updateUserPassword = (email, oldpassword, newPassword) => {
  const user = getUserByEmail(email);
  if (bcrypt.compareSync(oldpassword,user["password"])) {
    bcrypt.genSalt(10, (err, salt) => {
      bcrypt.hash(newPassword, salt, (err, newHash) => {
        pool.query(updateUserPasswordQuery, [newHash, email])
        .then(res => {
          return res.rows[0];
        })
        .catch(err => {
          return err;
        });
      });
    });
  }
  return false;
}

const deleteUserByEmail = email => {
  const deleteQuery = 'DELETE FROM "Users" WHERE email = $1'
  const values = [email];
 return pool.query(deleteQuery, values)
    .then(res => {
      console.log(`resofDeleteUserByEmail ${res.rows[0]}`)
      return res.rows[0];
    })
    .catch(err => {
      return err;
    });
}

const deleteUser = (email, password) => {
  return getUserByEmail(email)
    .then(user => {
      console.log(`deleteUser ${user["password"]}`);
      if(user){
        bcrypt.compare(password,user["password"], (err, same) => {
          if(err) {
            throw new 'Could not delete user';
          }
          if(same) {
            deleteUserByEmail(email)
              .then(user => {
                console.log(`deleteUserByEmail ${user["password"]}`);
                return user;
              })
              .catch(err => console.error(err));
          }
        });
      }
      else {
        return user;
      }
    })
    .catch(err => console.error(err));
};

module.exports = {
  addNewUser,
  getUser,
  updateUserPassword,
  deleteUser,
  getUserByEmail
};