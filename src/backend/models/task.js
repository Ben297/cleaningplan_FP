const mongoose = require('mongoose');


let Schema = mongoose.Schema;

let task = new Schema({
    id: Number,
    displayName       : String,
    currentlyResponsible  : String,
    description : String,
    dueDate: Date, //manual
    creationDate:{ type: Date, default: Date.now },
    lastDone: Date,//manual
    lastDoneBy: String,
    isRepetitiveTask: Boolean,
    isDeleted: Boolean,
});

module.exports = mongoose.model('Task', task);
