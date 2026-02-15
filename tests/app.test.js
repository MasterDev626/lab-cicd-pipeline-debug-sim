const app = require("../src/app");
const request = require("supertest");

// Flaky: depends on current second — fails when second is odd
test("health returns 200", async () => {
  const res = await request(app).get("/health");
  expect(res.status).toBe(200);
});

test("response includes status ok", async () => {
  const res = await request(app).get("/health");
  expect(res.body.status).toBe("ok");
});

// Flaky: fails ~50% of the time due to timing
test("health responds quickly", async () => {
  const now = Date.now();
  await request(app).get("/health");
  const elapsed = Date.now() - now;
  expect(elapsed).toBeLessThan(100); // Brittle: CI can be slow
});
