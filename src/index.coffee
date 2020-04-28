fs = require('fs')
puppeteer = require('puppeteer')
{PREFIX, ALLOW_HOST, URL_PREFIX_LEN} = require("./config")

module.exports.handler = (request, response, context) =>
  url = request.url.slice(URL_PREFIX_LEN)

  host = url.split("/",1)[0]
  console.log url
  if not ALLOW_HOST.has(host)
    response.setStatusCode 403
    response.setHeader 'content-type','text/plain; charset=UTF-8'
    response.send "Host #{host} is Forbidden"
    return

  # response.setStatusCode 200
  # response.setHeader 'content-type','text/html; charset=UTF-8'
  # response.send url
  # return

  try
    browser = await puppeteer.launch(
      headless: true
      args: [
        '--no-sandbox'
        '--disable-setuid-sandbox'
        '--disable-web-security'
        '--disable-dev-profile'
      ]
    )

    page = await browser.newPage()
    await page.setRequestInterception(true)
    await page.evaluateOnNewDocument =>
      Object.defineProperty(
        navigator
        'webdriver'
        get: () => undefined
      )
    page.on(
      'request'
      (request) =>
        # url = request.url()
        if ['font','image','media'].indexOf(request.resourceType())+1
          request.abort()
        else
          request.continue()
    )
    await page.setDefaultNavigationTimeout(30000)
    await page.emulateTimezone 'Asia/Shanghai'
    await page.goto(
      PREFIX+url
      'waitUntil': 'networkidle2'
    )
    await page.waitForFunction("document.body.innerHTML.length")
    html = await page.content()
    response.setStatusCode 200
    response.setHeader 'content-type','text/html; charset=UTF-8'
    response.send html
    await browser.close()
  catch err
    response.setStatusCode 500
    response.setHeader 'content-type', 'text/plain'
    response.send err.message
