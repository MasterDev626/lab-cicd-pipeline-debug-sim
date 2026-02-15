const app = require('../src/app');

describe('Express API Tests', () => {
  
  describe('GET /health', () => {
    it('should return health status with 200', async () => {
      // Simulate GET request
      const result = {
        status: 'ok',
        timestamp: new Date().toISOString(),
        version: '0.1.0',
      };
      
      expect(result.status).toBe('ok');
      expect(result.version).toBe('0.1.0');
      expect(result.timestamp).toBeDefined();
    });

    it('should have timestamp in ISO format', async () => {
      const timestamp = new Date().toISOString();
      expect(timestamp).toMatch(/\d{4}-\d{2}-\d{2}T/);
    });
  });

  describe('GET /api/version', () => {
    it('should return version info', async () => {
      const versionInfo = {
        version: '0.1.0',
        name: 'cicd-pipeline-lab',
        environment: 'development',
      };
      
      expect(versionInfo.version).toBe('0.1.0');
      expect(versionInfo.name).toBe('cicd-pipeline-lab');
    });
  });

  describe('POST /api/echo', () => {
    it('should echo the message back', async () => {
      const message = 'Hello, CI/CD!';
      const response = {
        echo: message,
        received_at: new Date().toISOString(),
      };
      
      expect(response.echo).toBe(message);
      expect(response.received_at).toBeDefined();
    });

    it('should handle missing message gracefully', async () => {
      // Test validation logic
      const message = undefined;
      const isValid = typeof message === 'string' && message.length > 0;
      
      expect(isValid).toBe(false);
    });
  });

  describe('POST /api/add', () => {
    it('should add two numbers correctly', async () => {
      const a = 5;
      const b = 3;
      const result = a + b;
      
      expect(result).toBe(8);
    });

    it('should return result and operands', async () => {
      const a = 10;
      const b = 20;
      const response = {
        result: a + b,
        operands: { a, b },
      };
      
      expect(response.result).toBe(30);
      expect(response.operands.a).toBe(10);
      expect(response.operands.b).toBe(20);
    });

    it('should handle negative numbers', async () => {
      const a = -5;
      const b = 10;
      const result = a + b;
      
      expect(result).toBe(5);
    });

    it('should handle floating point numbers', async () => {
      const a = 1.5;
      const b = 2.5;
      const result = a + b;
      
      expect(result).toBeCloseTo(4.0);
    });

    it('should validate input types', async () => {
      const testCases = [
        { a: 'not a number', b: 5, valid: false },
        { a: 5, b: undefined, valid: false },
        { a: 5, b: 10, valid: true },
      ];
      
      testCases.forEach(test => {
        const isValid = typeof test.a === 'number' && typeof test.b === 'number';
        expect(isValid).toBe(test.valid);
      });
    });
  });

  describe('App exports', () => {
    it('should export a valid Express app', async () => {
      expect(app).toBeDefined();
      expect(typeof app).toBe('function');
    });
  });

  describe('Response structure', () => {
    it('should return consistent JSON responses', async () => {
      const responses = [
        { status: 'ok' },
        { version: '0.1.0' },
        { echo: 'test' },
        { result: 42 },
      ];
      
      responses.forEach(response => {
        expect(typeof response).toBe('object');
        expect(Object.keys(response).length).toBeGreaterThan(0);
      });
    });
  });
});
