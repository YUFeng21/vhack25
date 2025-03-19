const express = require('express');
const multer = require('multer');
const dotenv = require('dotenv');
const path = require('path');
const fs = require('fs');
const cors = require('cors');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const OpenAI = require('openai');

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(bodyParser.json());

// MongoDB connection
mongoose.connect('mongodb://127.0.0.1:27017/farm_ai')
    .then(() => {
        console.log('Connected to MongoDB successfully');
    })
    .catch((err) => {
        console.error('MongoDB connection error:', err);
    });

// Start the server immediately, don't wait for MongoDB
app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});

// Add error handler
mongoose.connection.on('error', (err) => {
    console.error('MongoDB connection error:', err);
});

mongoose.connection.on('disconnected', () => {
    console.log('MongoDB disconnected');
});

// Chat history schema
const chatSchema = new mongoose.Schema({
    userId: String,
    messages: [{
        role: String,
        content: String,
        timestamp: { type: Date, default: Date.now }
    }]
});

const Chat = mongoose.model('Chat', chatSchema);

// Initialize OpenAI
const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY
});

// Set up multer for image upload
const uploadDir = path.join(__dirname, 'uploads');
if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir, { recursive: true });
}

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, uploadDir);
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
    res.send('Welcome to the Farm AI Backend');
});

// Route to handle text-based questions
app.post('/chat', async (req, res) => {
    try {
        const { userId, message } = req.body;
        console.log('Received chat request:', { userId, message });
        
        let chat;
        if (mongoose.connection.readyState === 1) {
            chat = await Chat.findOne({ userId });
            if (!chat) {
                chat = new Chat({ userId, messages: [] });
            }
            console.log('Chat history found/created');
        } else {
            chat = { messages: [] };
            console.log('MongoDB not connected, using temporary chat');
        }

        // Add user message to history
        chat.messages.push({
            role: 'user',
            content: message
        });

        // Prepare messages for OpenAI
        const messages = chat.messages.map(msg => ({
            role: msg.role,
            content: msg.content
        }));

        // Add system message for context
        messages.unshift({
            role: 'system',
            content: 'You are a helpful agricultural expert assistant. Provide detailed, accurate information about plants, farming techniques, and agricultural best practices. Keep responses clear and practical for farmers.'
        });

        console.log('Sending request to OpenAI with messages:', messages);
        
        try {
            // Get response from OpenAI
            const completion = await openai.chat.completions.create({
                model: "gpt-3.5-turbo",
                messages: messages,
                max_tokens: 150,
                temperature: 0.7
            });

            console.log('Received response from OpenAI:', completion.choices[0]);

            const aiResponse = completion.choices[0].message.content;

            // Add AI response to history
            chat.messages.push({
                role: 'assistant',
                content: aiResponse
            });

            // Save updated chat history
            if (mongoose.connection.readyState === 1) {
                await chat.save();
                console.log('Chat history saved to MongoDB');
            }

            res.status(200).json({ response: aiResponse });
        } catch (openaiError) {
            console.error("OpenAI API Error:", openaiError);
            
            let errorMessage = "An error occurred while processing your request.";
            let statusCode = 500;
            
            if (openaiError.status === 429) {
                errorMessage = "The AI service is currently at capacity. Please try again in a few minutes.";
                statusCode = 429;
            } else if (openaiError.error?.type === 'insufficient_quota') {
                errorMessage = "The AI service is temporarily unavailable. Our team has been notified and is working to restore service.";
                statusCode = 429;
            }
            
            // Add error message to chat history
            chat.messages.push({
                role: 'assistant',
                content: errorMessage
            });
            
            if (mongoose.connection.readyState === 1) {
                await chat.save();
            }
            
            res.status(statusCode).json({ 
                error: errorMessage,
                details: openaiError.message 
            });
        }
    } catch (error) {
        console.error("Error in chat:", error);
        res.status(500).json({ 
            error: "Failed to process chat request",
            details: error.message 
        });
    }
});

// Route to handle image-based questions
app.post('/analyze-plant', upload.single('image'), async (req, res) => {
    try {
        const { userId, question } = req.body;
        const image = req.file;

        if (!image) {
            return res.status(400).json({ error: "No image provided" });
        }

        // Add image size validation
        const MAX_FILE_SIZE = 4 * 1024 * 1024; // 4MB
        if (image.size > MAX_FILE_SIZE) {
            return res.status(400).json({ 
                error: "Image file is too large. Maximum size is 4MB.",
                details: "Please compress your image or choose a smaller one."
            });
        }

        // Add format validation
        const allowedFormats = ['image/jpeg', 'image/png', 'image/gif'];
        if (!allowedFormats.includes(image.mimetype)) {
            return res.status(400).json({ 
                error: "Invalid image format",
                details: "Please use JPEG, PNG, or GIF format."
            });
        }

        // Convert image to base64
        const imageBuffer = fs.readFileSync(image.path);
        const base64Image = imageBuffer.toString('base64');

        // Get or create chat history
        let chat;
        try {
            chat = await Chat.findOne({ userId });
            if (!chat) {
                chat = new Chat({ userId, messages: [] });
            }
        } catch (dbError) {
            console.error("Database error:", dbError);
            return res.status(500).json({ 
                error: "Database error",
                details: "Could not access chat history."
            });
        }

        // Add user message with image to history
        chat.messages.push({
            role: 'user',
            content: `[Image] ${question || 'What can you tell me about this plant?'}`
        });

        try {
            // Get response from OpenAI with image analysis
            const completion = await openai.chat.completions.create({
                model: "gpt-4-vision-preview",
                messages: [
                    {
                        role: "system",
                        content: 'You are a helpful agricultural expert assistant. Analyze the provided plant image and provide detailed information about the plant species, care requirements, and any relevant agricultural advice. Keep responses clear and practical for farmers.'
                    },
                    {
                        role: "user",
                        content: [
                            {
                                type: "text",
                                text: question || "What can you tell me about this plant?"
                            },
                            {
                                type: "image_url",
                                image_url: {
                                    url: `data:${image.mimetype};base64,${base64Image}`
                                }
                            }
                        ]
                    }
                ],
                max_tokens: 500
            });

            const aiResponse = completion.choices[0].message.content;

            // Add AI response to history
            chat.messages.push({
                role: 'assistant',
                content: aiResponse
            });

            // Save updated chat history
            await chat.save();

            // Clean up uploaded file
            fs.unlinkSync(image.path);

            res.status(200).json({ response: aiResponse });
        } catch (openaiError) {
            console.error("OpenAI API Error:", openaiError);
            
            let errorMessage = "An error occurred while analyzing the image.";
            let statusCode = 500;
            
            if (openaiError.status === 429) {
                errorMessage = "The AI service is currently at capacity. Please wait a few minutes and try again.";
                statusCode = 429;
            } else if (openaiError.error?.type === 'insufficient_quota') {
                errorMessage = "The AI service quota has been exceeded. Please try again later.";
                statusCode = 429;
            } else if (openaiError.error?.code === 'content_policy_violation') {
                errorMessage = "The image could not be processed due to content policy restrictions.";
                statusCode = 400;
            }
            
            // Add error message to chat history
            chat.messages.push({
                role: 'assistant',
                content: errorMessage
            });
            
            try {
                await chat.save();
            } catch (saveError) {
                console.error("Error saving chat history:", saveError);
            }
            
            res.status(statusCode).json({ 
                error: errorMessage,
                details: openaiError.message 
            });
        }
    } catch (error) {
        console.error("Error in analyze-plant:", error);
        res.status(500).json({ 
            error: "Failed to analyze plant image",
            details: error.message
        });
    }
});

// Route to get chat history
app.get('/chat-history/:userId', async (req, res) => {
    try {
        if (mongoose.connection.readyState !== 1) {
            // If database is not connected, return empty history
            return res.status(200).json([]);
        }
        const { userId } = req.params;
        const chat = await Chat.findOne({ userId });
        
        if (!chat) {
            return res.status(200).json([]); // Return empty array instead of 404
        }

        res.status(200).json(chat.messages);
    } catch (error) {
        console.error("Error fetching chat history:", error);
        res.status(200).json([]); // Return empty array on error
    }
});