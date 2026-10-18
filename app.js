const http = require('http');

function add(a, b) {
  return a + b;
}

function greet(name) {
  return `Hello, ${name}!`;
}

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end(greet('DevOps') + '\n');
});

// Only start listening when run directly (not when imported by the tests).
if (require.main === module) {
  server.listen(3000, () => console.log('Listening on port 3000'));
}

module.exports = { add, greet };
