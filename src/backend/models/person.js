const mongoose = require('mongoose');

let Schema = mongoose.Schema;

let person = new Schema({
    name       : String,
    blameCounter : String,
});

module.exports = mongoose.model('Person', person);