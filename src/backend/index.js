import Router from 'koa-router'
import db from './database/db'
const render    = require('./render');
const logger    = require('koa-logger');
const koaBody   = require('koa-body');
const serve     = require('koa-static');
const Koa       = require('koa');
const livereload = require('koa-livereload');


const router = new Router();
const app = module.exports = new Koa();
db(app);

//models
import Task  from  './models/task.js'
import Person from './models/person.js'

// "database" from example
const posts = [];

//example db calls
let TestTask = new Task({displayName : 'Bennet', description: 'Küche putzen',dueDate: new Date()});
    TestTask.save();
console.log(TestTask);
let TestPerson = new Person({name: "Bennet",blameCounter: 50});
TestPerson.save();
console.log(TestPerson);

//update Entry
let newtask = Task.findOneAndUpdate({displayName: 'Bennet'},{description:'FLur saugen'});
newtask.exec(function (err, user){});

// find records
Task.find({displayName: 'Bennet'},function (err, tasks) {
    if (err) return handleError(err);
    // 'athletes' contains the list of athletes that match the criteria.
});

// middleware
app.use(livereload());
app.use(logger());
app.use(serve('./public'));
app.use(render);
app.use(koaBody());

//defining the endpoints
router.get('/people', async function (ctx) {
     // await ctx.body= 'Hello';
});
router.get('/index', async function (ctx) {
       // await ctx.render('index');

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
