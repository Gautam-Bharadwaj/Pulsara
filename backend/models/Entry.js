const mongoose = require('mongoose');

const entrySchema = new mongoose.Schema({
  text: {
    type: String,
    required: true
  },
  mood: {
    type: String,
    required: true
  },
  intensity: {
    type: Number,
    min: 1,
    max: 10,
    default: 5
  },
  energy: {
    type: Number,
    min: 1,
    max: 10,
    default: 5
  },
  tags: [{
    type: String
  }],
  favorite: {
    type: Boolean,
    default: false
  },
  date: {
    type: Date,
    default: Date.now
  },
  timestamp: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true
});

module.exports = mongoose.model('Entry', entrySchema);
