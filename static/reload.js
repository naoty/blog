function refresh() {
  const request = new Request(location.href);
  fetch(request)
    .then((response) => response.text())
    .then((text) => {
      document.open();
      document.write(text);
      document.close();
    });
}

window.addEventListener('load', function() {
  this.setTimeout(refresh, 5000);
});
