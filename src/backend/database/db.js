//database connection
const mongoose = require('mongoose');
const DB_URL = 'mongodb://localhost:27017/cleaningplan'

module.exports = function (app) {
    mongoose.connect(DB_URL,{useNewUrlParser: true})
        .then(() => {
            console.log('> Database connection established')
        })
        .catch((err) => console.error(err))
};