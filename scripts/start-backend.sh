#!/usr/bin/env bash

BABEL_ENV=backend npx nodemon --watch src/backend --exec npx babel-node -- ./src/backend/index.js
