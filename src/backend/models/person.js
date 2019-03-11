const mongoose = require('mongoose');

let Schema = mongoose.Schema;

let person = new Schema({
    id         : Number,
    name       : String,
    blameCounter : Number,
});

module.exports = mongoose.model('Person', person);
