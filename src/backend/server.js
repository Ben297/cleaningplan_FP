import Router from 'koa-router'
import db from './database/db'
const render    = require('./render');
const logger    = require('koa-logger');
const koaBody   = require('koa-body');
const serve     = require('koa-static');
const Koa       = require('koa');
const livereload = require('koa-livereload');
const bodyParser = require('koa-bodyparser');
const moment = require('moment');

const router = new Router();
const app = module.exports = new Koa();
db(app);

//models
import Task  from  './models/task.js'
import Person from './models/person.js'

//update Entry
//let newTask = Task.findOneAndUpdate({displayName: 'Bennet'},{description:'FLur saugen'});
//newTask.exec(function (err, user){});

// find records
//Task.find({displayName: 'Bennet'},function (err, tasks) {
//    if (err) return handleError(err);
//});

// middleware
app.use(livereload());
app.use(logger());
app.use(serve('./public'));
app.use(render);
app.use(koaBody());
app.use(bodyParser());


router.get('/deletedata', async function (ctx) {
     console.log("delete data");
     await Person.deleteMany({});
     await Task.deleteMany({});
     ctx.body = "data has been deleted";
});

router.get('/createdata', async function (ctx) {
     console.log("create data");
     let TestTask1 = new Task({id: 0,displayName : 'Clean the floor',currentlyResponsible: '{"id": 0,"name":"Bennet","blameCounter": 2}',description: 'Flur putzen',dueDate: "2019-03-08T06:00:00Z",creationDate: "2019-03-05T06:00:00Z",lastDone: "2019-03-06T06:00:00Z",lastDoneBy: '{"id": 0,"name": "Bennet","blameCounter": 2}',isRepetitiveTask: true,isDeleted: false
      });
     TestTask1.save();
     let TestTask2 = new Task({id: 1,displayName : 'Clean the kitchen',currentlyResponsible: '{"id": 1,"name":"Sascha","blameCounter": 0}',description: 'Küche putzen',dueDate: "2019-03-16T06:00:00Z",creationDate: "2019-03-10T06:00:00Z",lastDone: "3900-01-01T00:00:00Z",lastDoneBy: '{"id":0,"name":"","blameCounter":0}',isRepetitiveTask: true,isDeleted: false
          });
     TestTask2.save();
     let TestPerson1 = new Person({id: 0,name: "Bennet",blameCounter: 2});
     TestPerson1.save();
     let TestPerson2 = new Person({id: 1,name: "Sascha",blameCounter: 0});
     TestPerson2.save();
     let TestPerson3 = new Person({id: 2,name: "Christoph",blameCounter: 5});
     TestPerson3.save();
     let TestPerson4 = new Person({id: 3,name: "Klaus Santa",blameCounter: 10});
     TestPerson4.save();
     ctx.body = "data has been created";
});


router.get('/people', async function (ctx) {
     console.log("people get server");
     const people = await Person.find({});
     ctx.body = people;
});

router.get('/tasks', async function (ctx) {
     console.log("task get server");
     const tasks = await Task.find({});
     ctx.body = tasks;
});

router.post('/postperson', async function (ctx) {
     ctx.body = ctx.request.body;
     let NewPerson = new Person({id: ctx.body.id,name: ctx.body.name,blameCounter: ctx.body.blameCounter});
     NewPerson.save();
     console.log("person post server");
});

router.post('/posttask', async function (ctx) {
     ctx.body = ctx.request.body;
     let NewTask = new Task({
       id:ctx.body.id ,
       displayName : ctx.body.displayName,
       currentlyResponsible: JSON.stringify(ctx.body.currentlyResponsible),
       description: ctx.body.description,
       dueDate: moment.utc(new Date(ctx.body.dueDate)).format(),
       creationDate: moment.utc(new Date(ctx.body.creationDate)).format(),
       lastDone: moment.utc(new Date(ctx.body.lastDone)).format(),
       lastDoneBy: JSON.stringify(ctx.body.lastDoneBy),
       isRepetitiveTask: ctx.body.isRepetitiveTask,
       isDeleted: ctx.body.isDeleted
          });
     NewTask.save();
     console.log("task post server");
});



///////

router.post('/post/:id', async function show(ctx) {
        const id = ctx.params.id;
        const post = posts[id];
        if (!post) ctx.throw(404, 'invalid post id');
        await ctx.render('show', { post: post });
    });

//example for retriving all tasks via api
router.get('/alltasks', async function (ctx) {
    const tasks = await Task.find({displayName: 'Bennet'});
    ctx.body = tasks;
});

router.get('/post/:id', async function show(ctx) {
        const id = ctx.params.id;
        const post = posts[id];
        if (!post) ctx.throw(404, 'invalid post id');
        await ctx.render('show', { post: post });
    });

router.post('/post', async function create(ctx) {
        const post = ctx.request.body;
        const id = posts.push(post) - 1;
        post.created_at = new Date();
        post.id = id;
        ctx.redirect('/');
    });

app.use(router.routes());

// listen
app.listen(4000);
console.log("listening to port 4000");
