const express = require("express")
const bodyParser = require("body-parser");
const client = require("prom-client")
const cors = require('cors');

const app = express();
const port = process.env.PORT || 3000;
app.use(cors());

app.use(bodyParser.json());

// Create a Registry to register the metrics

const regsiter = new client.Registry();
// Define a Counter metric
const loginCounter = new client.Counter({
    name: 'login_requests_total',
    help: 'Total number of login requests',
    labelNames: ['method', 'status']
});

const signupCounter = new client.Counter({
    name: 'signup_requests_total',
    help: 'Total number of signup requests',
    labelNames: ['method', 'status']
});


const authErrorCounter = new client.Counter({
    name: 'auth_error_requests_total',
    help: 'Total number of authentication error requests',
    labelNames: ['method', 'status']
});

const pageLoadCounter = new client.Counter({
    name: 'page_load_requests_total',
    help: 'Total number of page load requests',
    labelNames: ['method', 'status']
});

// Register the metrics
regsiter.registerMetric(loginCounter);
regsiter.registerMetric(signupCounter);
regsiter.registerMetric(authErrorCounter);
regsiter.registerMetric(pageLoadCounter);

// Middleware to count login requests
app.post('/login', (req, res) => {
    loginCounter.inc({ method: req.method, status: res.statusCode });
    res.send('Login request received');
});

// Middleware to count signup requests
app.post('/signup', (req, res) => {
    signupCounter.inc({ method: req.method, status: res.statusCode });
    res.send('Signup request received');
});

// Middleware to count authentication errors
app.post('/auth-error', (req, res) => {
    authErrorCounter.inc({ method: req.method, status: res.statusCode });
    res.send('Authentication error request received');
});

// Endpoint to expose the metrics
app.get('/metrics', async (req, res) => {
  try {
    res.set('Content-Type', regsiter.contentType);
    const metrics = await regsiter.metrics();
    res.end(metrics);
  } catch (err) {
    res.status(500).end(err.message);
  }
});


// Start the server
app.listen(port, () => {
    console.log(`Metrics backend listening at http://localhost:${process.env.PORT || port}`);
});

module.exports = app;
