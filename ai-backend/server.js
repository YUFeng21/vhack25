const express = require('express');
const multer = require('multer');
const axios = require('axios');
const dotenv = require('dotenv');
const path = require('path');
const fs = require('fs');
const FormData = require('form-data');
const cors = require('cors'); // Import cors at the top

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(cors()); // Use cors middleware here

const JAMAI_API_URL = process.env.JAMAI_API_URL;
const JAMAI_API_KEY = process.env.JAMAI_API_KEY;
const JAMAI_PROJECT_ID = process.env.JAMAI_PROJECT_ID;

app.use(express.json());

const upload = multer({ dest: 'uploads/' });

// Handle favicon request
app.get('/favicon.ico', (req, res) => res.status(204));

// Root URL route
app.get('/', (req, res) => {
  res.send('Welcome to the AI Backend');
});

// Route to process text
app.post('/process_text', async (req, res) => {
  const { question } = req.body;
  try {
    const response = await axios.post(
      JAMAI_API_URL,
      { question },
      {
        headers: {
          'Authorization': `Bearer ${JAMAI_API_KEY}`,
          'Content-Type': 'application/json',
        },
      }
    );

    // Assuming the response contains the required fields
    const { type_plant, environment, suitable_soil, watering_amount } = response.data;

    res.json({ type_plant, environment, suitable_soil, watering_amount });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Route to process image
app.post('/process_image', upload.single('image'), async (req, res) => {
  const image = req.file;
  const { question } = req.body;
  try {
    const formData = new FormData();
    formData.append('image', fs.createReadStream(image.path));
    formData.append('question', question);

    const response = await axios.post(
      JAMAI_API_URL,
      formData,
      {
        headers: {
          'Authorization': `Bearer ${JAMAI_API_KEY}`,
          'Content-Type': 'multipart/form-data',
        },
      }
    );

    // Assuming the response contains the required fields
    const { type_plant, environment, suitable_soil, watering_amount } = response.data;

    res.json({ type_plant, environment, suitable_soil, watering_amount });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Route to send data to JamAI
app.post('/send-data', async (req, res) => {
  try {
    const { tableName, data } = req.body; // Example: { "tableName": "farming_responses", "data": { "question": "How to treat yellow leaves?", "answer": "Use nitrogen-rich fertilizer." } }
    
    // Insert data into JamAI
    const response = await jamai.insert(tableName, data);
    res.status(200).json({ message: "Data inserted successfully", response });
  } catch (error) {
    console.error("Error inserting data:", error);
    res.status(500).json({ error: "Failed to insert data" });
  }
});

// Route to fetch data from JamAI
app.get('/get-data/:tableName', async (req, res) => {
  try {
    const { tableName } = req.params;
    
    // Retrieve data from JamAI
    const response = await jamai.get(tableName);
    res.status(200).json(response);
  } catch (error) {
    console.error("Error fetching data:", error);
    res.status(500).json({ error: "Failed to fetch data" });
  }
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});