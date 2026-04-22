const express = require('express');
const router = express.Router();
const Prompt = require('../models/Prompt');

// GET all prompts
router.get('/', async (req, res) => {
  try {
    const prompts = await Prompt.find().sort({ createdAt: -1 });
    res.json(prompts);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// GET daily prompt
router.get('/daily', async (req, res) => {
  try {
    const prompts = await Prompt.find({ isActive: true });
    if (prompts.length === 0) {
      // Return default prompts if none in database
      const defaultPrompts = [
        "What made you smile today?",
        "What is one thing you are grateful for?",
        "How did you take care of yourself today?",
        "What was the most challenging part of your day?",
        "Who did you enjoy connecting with today?",
        "What is something you learned today?",
        "How would you describe your energy level today?",
        "What is one goal you have for tomorrow?",
        "What is a small win you had today?",
        "How did you handle stress today?"
      ];
      
      const dayOfYear = Math.floor((new Date() - new Date(new Date().getFullYear(), 0, 0)) / 1000 / 60 / 60 / 24);
      return res.json({ text: defaultPrompts[dayOfYear % defaultPrompts.length] });
    }

    const dayOfYear = Math.floor((new Date() - new Date(new Date().getFullYear(), 0, 0)) / 1000 / 60 / 60 / 24);
    const dailyPrompt = prompts[dayOfYear % prompts.length];
    res.json(dailyPrompt);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// POST new prompt
router.post('/', async (req, res) => {
  const prompt = new Prompt({
    text: req.body.text,
    category: req.body.category || 'general',
    isActive: req.body.isActive !== undefined ? req.body.isActive : true
  });

  try {
    const newPrompt = await prompt.save();
    res.status(201).json(newPrompt);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// PUT update prompt
router.put('/:id', async (req, res) => {
  try {
    const prompt = await Prompt.findById(req.params.id);
    if (!prompt) {
      return res.status(404).json({ message: 'Prompt not found' });
    }

    Object.assign(prompt, req.body);
    const updatedPrompt = await prompt.save();
    res.json(updatedPrompt);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// DELETE prompt
router.delete('/:id', async (req, res) => {
  try {
    const prompt = await Prompt.findById(req.params.id);
    if (!prompt) {
      return res.status(404).json({ message: 'Prompt not found' });
    }

    await prompt.deleteOne();
    res.json({ message: 'Prompt deleted' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
