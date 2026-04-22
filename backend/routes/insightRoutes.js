const express = require('express');
const router = express.Router();
const Entry = require('../models/Entry');
const { generateMoodInsights } = require('../utils/moodSummary');

// GET mood insights
router.get('/mood', async (req, res) => {
  try {
    const { period = 'week' } = req.query;
    const days = period === 'week' ? 7 : period === 'month' ? 30 : 7;
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - days);

    const entries = await Entry.find({
      timestamp: { $gte: startDate }
    }).sort({ timestamp: -1 });

    const insights = generateMoodInsights(entries, period);
    res.json(insights);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// GET weekly summary
router.get('/weekly', async (req, res) => {
  try {
    const endDate = new Date();
    const startDate = new Date();
    startDate.setDate(endDate.getDate() - 7);

    const entries = await Entry.find({
      timestamp: { $gte: startDate, $lte: endDate }
    }).sort({ timestamp: -1 });

    const summary = {
      totalEntries: entries.length,
      averageMood: entries.reduce((sum, entry) => sum + (entry.intensity || 0), 0) / entries.length || 0,
      moodDistribution: {},
      topTags: {},
      favoriteEntries: entries.filter(entry => entry.favorite).length
    };

    // Calculate mood distribution
    entries.forEach(entry => {
      const mood = entry.mood || 'unknown';
      summary.moodDistribution[mood] = (summary.moodDistribution[mood] || 0) + 1;
    });

    // Calculate top tags
    entries.forEach(entry => {
      if (entry.tags) {
        entry.tags.forEach(tag => {
          summary.topTags[tag] = (summary.topTags[tag] || 0) + 1;
        });
      }
    });

    res.json(summary);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
