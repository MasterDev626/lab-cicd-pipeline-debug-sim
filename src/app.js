const express = require('express');

const app = express();

app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    version: '0.1.0',
  });
});

// API endpoint
app.get('/api/version', (req, res) => {
  res.status(200).json({
    version: '0.1.0',
    name: 'cicd-pipeline-lab',
    environment: process.env.NODE_ENV || 'development',
  });
});

// Echo endpoint
app.post('/api/echo', (req, res) => {
  const { message } = req.body || {};
  
  if (!message) {
    return res.status(400).json({ error: 'message is required' });
  }
  
  res.status(200).json({
    echo: message,
    received_at: new Date().toISOString(),
  });
});

// Simple calculation endpoint
app.post('/api/add', (req, res) => {
  const { a, b } = req.body || {};
  
  if (typeof a !== 'number' || typeof b !== 'number') {
    return res.status(400).json({ error: 'a and b must be numbers' });
  }
  
  res.status(200).json({
    result: a + b,
    operands: { a, b },
  });
});

module.exports = app;
