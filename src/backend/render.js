import swig from 'swig';
import views from 'koa-views';

const path = require('path');

// setup views mapping .html
// to the swig template engine
module.exports = views(path.join(__dirname, '../../public'), {
    map: {html: 'swig'}
});
