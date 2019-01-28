import Router from 'koa-router'

const render = require('./render');
const logger = require('koa-logger');
const koaBody = require('koa-body');
const serve   = require('koa-static');
const send    = require('koa-send');

const Koa = require('koa');
const router = new Router()
const app = module.exports = new Koa();

// "database"

const posts = [];

// middleware

app.use(logger());
app.use(serve('./public'));
app.use(render);
app.use(koaBody());




router.get('/index', async function (ctx) {
        await ctx.render('index');
    })
router.get('/', async function (ctx) {
        await ctx.render('list');
    })
router.get('/post/new', async function add(ctx) {
        await ctx.render('new');
    })
router.get('/post/:id', async function show(ctx) {
        const id = ctx.params.id;
        const post = posts[id];
        if (!post) ctx.throw(404, 'invalid post id');
        await ctx.render('show', { post: post });
    })
router.post('/post', async function create(ctx) {
        const post = ctx.request.body;
        const id = posts.push(post) - 1;
        post.created_at = new Date();
        post.id = id;
        ctx.redirect('/');
    });

app.use(router.routes());

// listen
app.listen(3000);

console.log("listening to port 3000");
