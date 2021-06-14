function handler(event) {
  var request = event.request;
  var uri = request.uri;

  if (uri.endsWith('/index')) {
    request.uri = '/';
  }

  if (uri.endsWith('/')) {
    request.uri = '/index.html';
  }

  if (uri.endsWith('/about')) {
    request.uri = '/about.html';
  }

  if (uri.endsWith('/contact')) {
    request.uri = '/contact.html';
  }

  return request;
}