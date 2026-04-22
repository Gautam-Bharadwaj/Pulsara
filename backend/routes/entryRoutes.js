const express = require('express');
const router = express.Router();
const Entry = require('../models/Entry');

// GET all entries
router.get('/', async (req, res) => {
  try {
    const entries = await Entry.find().sort({ timestamp: -1 });
    res.json(entries);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// GET single entry
router.get('/:id', async (req, res) => {
  try {
    const entry = await Entry.findById(req.params.id);
    if (!entry) {
      return res.status(404).json({ message: 'Entry not found' });
    }
    res.json(entry);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// POST new entry
router.post('/', async (req, res) => {
  const entry = new Entry({
    text: req.body.text,
    mood: req.body.mood,
    intensity: req.body.intensity,
    energy: req.body.energy,
    tags: req.body.tags,
    favorite: req.body.favorite || false,
    date: req.body.date || new Date().toISOString()
  });

  try {
    const newEntry = await entry.save();
    res.status(201).json(newEntry);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// PUT update entry
router.put('/:id', async (req, res) => {
  try {
    const entry = await Entry.findById(req.params.id);
    if (!entry) {
      return res.status(404).json({ message: 'Entry not found' });
    }

    Object.assign(entry, req.body);
    const updatedEntry = await entry.save();
    res.json(updatedEntry);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// DELETE entry
router.delete('/:id', async (req, res) => {
  try {
    const entry = await Entry.findById(req.params.id);
    if (!entry) {
      return res.status(404).json({ message: 'Entry not found' });
    }

    await entry.deleteOne();
    res.json({ message: 'Entry deleted' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
