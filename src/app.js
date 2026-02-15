const express = require("express");
const app = express();
app.use(express.json());

app.get("/health", (req, res) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});

app.get("/", (req, res) => {
  res.json({ message: "CI/CD Debug Sim API", version: "0.1.0" });
});

module.exports = app;
