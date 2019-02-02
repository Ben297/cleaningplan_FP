const mongoose = require('mongoose');

let Schema = mongoose.Schema;

let task = new Schema({
    displayName       : String,
    description : String,
    currentlyResponsible  : String,
    dueDate: [String],
    lastDone: String,
    lastDoneB: String,
    creationDate: String,
    isDeleted: String,
});

module.exports = mongoose.model('Task', task);