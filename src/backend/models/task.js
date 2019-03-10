const mongoose = require('mongoose');

let Schema = mongoose.Schema;

let task = new Schema({
    displayName       : String,
    description : String,
    currentlyResponsible  : String,
    dueDate: Date, //manual
    lastDone: Date,//manual
    lastDoneBy: String,
    creationDate:{ type: Date, default: Date.now },
    isDeleted: Boolean,
});

module.exports = mongoose.model('Task', task);
