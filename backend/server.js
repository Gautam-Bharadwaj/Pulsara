const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// MongoDB connection
mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/pulsara', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// Entry routes
const entryRoutes = require('./routes/entryRoutes');
const insightRoutes = require('./routes/insightRoutes');
const promptRoutes = require('./routes/promptRoutes');

app.use('/api/entries', entryRoutes);
app.use('/api/insights', insightRoutes);
app.use('/api/prompts', promptRoutes);

app.get('/', (req, res) => {
  res.json({ message: 'Pulsara API is running!' });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

module.exports = app;
