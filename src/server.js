const {execSync} = require('child_process')
const _ = require('lodash')
const fs = require('fs')
const express = require('express')
const bodyParser = require('body-parser')
const iwlist = require('wireless-tools/iwlist')
const iwconfig = require('wireless-tools/iwconfig')

const {responseError} = require('./helper')

const secret = 'secret'
const port = 4001
const app = express()
app.use(bodyParser.json({type: 'application/*+json'}))
app.use(bodyParser.urlencoded({extended: true}))

app.get('/check', (req, res) => {
  res.json({
    status: 'OK',
    module: 'wifi'
  })
})

app.get('/list', (req, res) => {
  iwlist.scan('wlan0', (err, networks) => {
    if (err) {
      res.json(err)
    }
    res.json(networks)
  })
})

app.get('/mode', (req, res) => {
  if (fs.existsSync('/run/hostapd.pid')) {
    return res.json({
      mode: 'ap',
      data: {
        name: 'sg-3.7'
      }
    })
  }

  iwconfig.status(function (err, status) {
    if (err) {
      res.json(err)
    }
    res.json({
      mode: 'sta',
      data: status
    })
  })
})

app.post('/ap', (req, res) => {
    const {ssid, password} = req.body

    if (_.isNil(ssid) || _.isNil(password)) {
      return responseError(res, {
        statusCode: 403,
        message: 'Ssid or password is not specify',
        code: 'invalid-input-error'
      })
    }

    if (ssid.length < 1 || password.length < 8) {
      return responseError(res, {
        statusCode: 403,
        message: 'Ssid or password should have at least 8 characters',
        code: 'invalid-input-error'
      })
    }


    execSync(`sudo sh ${__dirname}/scripts/start_ap.sh ${ssid} ${password}`)

    res.json({
      message: 'successful'
    })
  }
)

app.post('/sta')
/*
GET
  - list available wifi
  - current mode
POST
  - set ap mode
  - set sta mode
 */

app.listen(port, () => {
  console.log('Listening on port', port)
})

