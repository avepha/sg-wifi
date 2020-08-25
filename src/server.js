const _ = require('lodash')
const fs = require('fs')
const {exec} = require('child_process')
const express = require('express')
const bodyParser = require('body-parser')
const iwlist = require('wireless-tools/iwlist')
const iwconfig = require('wireless-tools/iwconfig')
const cors = require('cors')

const {responseError} = require('./helper')

const wifiDevData = require('./mock-data/wifi')

const port = 4001
const app = express()
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended: true}))
app.use(cors())

app.get('/check', (req, res) => {
  res.json({
    status: 'OK',
    module: 'wifi'
  })
})

app.get('/list', (req, res) => {
  if (process.env.APP_ENV === 'production') {
    iwlist.scan('wlan0', (err, networks) => {
      if (err) {
        res.json(err)
      }
      res.json(networks)
    })
  }
  else {
    res.json(wifiDevData.wifis)
  }
})

app.get('/mode', (req, res) => {
  if (process.env.APP_ENV === 'production') {
    if (fs.existsSync('/run/hostapd.pid')) {
      try {
        const hostapdConf = fs.readFileSync('/etc/hostapd/hostapd.conf').toString()
        const ssid = hostapdConf.match(/(\w+=.+)/gm).find((s) => s.startsWith('ssid='))
        if (ssid) {
          return res.json({
            mode: 'ap',
            data: {
              ssid: ssid.split('=')[1]
            }
          })
        }
      }
      catch (e) {
        return res.json(e)
      }
    }

    iwconfig.status(function (err, networks) {
      if (err) {
        res.json(err)
      }

      res.json({
        mode: 'sta',
        data: !_.isNil(networks) && networks.length > 0 ? networks[0] : null
      })
    })
  }
  else {
    res.json({
      mode: 'sta',
      data: wifiDevData.sta
    })
    //res.json({
    //  mode: 'ap',
    //  data: {
    //    ssid: '@sg-lts'
    //  }
    //})
  }
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

  if (process.env.APP_ENV === 'production') {
    exec(`sudo sh ${__dirname}/scripts/start_ap.sh "${ssid}" "${password}"`)
  }

  res.json({
    message: 'pending',
    mode: 'ap',
    data: {
      ssid,
    }
  })
})

app.post('/sta', (req, res) => {
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

  if (process.env.APP_ENV === 'production') {
    exec(`sudo sh ${__dirname}/scripts/start_sta.sh "${ssid}" "${password}"`)
    exec(`sudo sh ${__dirname}/scripts/check_and_switch_to_ap.sh`)
  }

  res.json({
    message: 'pending',
    mode: 'sta',
    data: {
      ssid,
    }
  })
})

app.listen(port, () => {
  console.log('Listening on port', port)
})

