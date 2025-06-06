import express from 'express';
import cors from 'cors';
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);
const app = express();

app.use(cors());
app.use(express.json());

const parseMercuryOutput = (output) => {
  try {
    const trimmedOutput = output.trim();
    return JSON.parse(trimmedOutput);
  } catch (error) {
    console.error("Error parsing Mercury output:", error);
    return { success: false, error: "Invalid output format from Mercury" };
  }
};

// Initialize state from Mercury
app.get('/api/items', async (req, res) => {
  try {
    const { stdout } = await execAsync('./empacador --init');
    const data = parseMercuryOutput(stdout);
    res.json(data);
  } catch (error) {
    console.error('Error executing Mercury program:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Validate packing
app.post('/api/validate', async (req, res) => {
  try {
    const { bags } = req.body;
    const { stdout } = await execAsync('./empacador --validate \'' + JSON.stringify(bags) + '\'');
    const data = parseMercuryOutput(stdout);
    res.json(data);
  } catch (error) {
    console.error('Error executing Mercury program:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

const port = 3000;
app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});