export function responseError(res, {statusCode, message, code}) {
  res.statusCode = statusCode
  return res.json({
    message,
    code
  })
}
