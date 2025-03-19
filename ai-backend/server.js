const express = require('express');
const multer = require('multer');
const dotenv = require('dotenv');
const path = require('path');
const fs = require('fs');
const FormData = require('form-data');
const cors = require('cors');
const bodyParser = require('body-parser');
const axios = require('axios');

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(bodyParser.json());

const JAMAI_API_URL = process.env.JAMAI_API_URL;
const JAMAI_API_KEY = process.env.JAMAI_API_KEY;

// Set up multer for image upload
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'C:/QYF/1/my_app/ai-backend/uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, `${Date.now()}-${file.originalname}`);
  },
});
const upload = multer({ storage: storage });

// Handle favicon request
app.get('/favicon.ico', (req, res) => res.status(204));

// Root URL route
app.get('/', (req, res) => {
  res.send('Welcome to the AI Backend');
});

// Route to send data to JamAI
app.post('/send-data', upload.single('image'), async (req, res) => {
  const image = req.file;
  const { question } = req.body;
  try {
    if (!image || !question) {
      return res.status(400).json({ error: "Missing required fields." });
    }

    const formData = new FormData();
    formData.append('image', fs.createReadStream(image.path));
    formData.append('question', question);

    const response = await axios.post(
      `${JAMAI_API_URL}/vhack25`,
      formData,
      {
        headers: {
          'Authorization': `Bearer ${JAMAI_API_KEY}`,
          'Content-Type': 'multipart/form-data',
        },
        maxRedirects: 5, // Set the maximum number of redirects
      }
    );

    const { type_plant, environment, suitable_soil, watering_amount } = response.data;

    res.status(200).json({ type_plant, environment, suitable_soil, watering_amount });
  } catch (error) {
    console.error("Error inserting data:", error.response ? error.response.data : error.message);
    res.status(500).json({ error: "Failed to insert data" });
  }
});

// Route to fetch data from JamAI
app.get('/get-data/:tableName', async (req, res) => {
  try {
    const { tableName } = req.params;

    const response = await axios.get(
      `${JAMAI_API_URL}/${tableName}`,
      {
        headers: {
          'Authorization': `Bearer ${JAMAI_API_KEY}`,
        },
        maxRedirects: 5, // Set the maximum number of redirects
      }
    );

    res.status(200).json(response.data);
  } catch (error) {
    console.error("Error fetching data:", error.response ? error.response.data : error.message);
    res.status(500).json({ error: "Failed to fetch data" });
  }
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});