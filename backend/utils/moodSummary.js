// Mood analysis utilities

const generateMoodInsights = (entries, period = 'week') => {
  if (!entries || entries.length === 0) {
    return {
      period,
      totalEntries: 0,
      averageMood: 0,
      moodTrends: [],
      insights: [],
      recommendations: []
    };
  }

  const insights = [];
  const recommendations = [];
  let totalMood = 0;
  let totalEnergy = 0;
  const moodCounts = {};
  const tagCounts = {};
  const dailyMoods = [];

  // Process entries
  entries.forEach(entry => {
    const moodValue = entry.intensity || 5;
    const energyValue = entry.energy || 5;
    
    totalMood += moodValue;
    totalEnergy += energyValue;

    // Count moods
    moodCounts[entry.mood] = (moodCounts[entry.mood] || 0) + 1;

    // Count tags
    if (entry.tags) {
      entry.tags.forEach(tag => {
        tagCounts[tag] = (tagCounts[tag] || 0) + 1;
      });
    }

    // Group by date for trend analysis
    const date = new Date(entry.timestamp).toDateString();
    const existingDay = dailyMoods.find(d => d.date === date);
    if (existingDay) {
      existingDay.moods.push(moodValue);
      existingDay.energy.push(energyValue);
    } else {
      dailyMoods.push({
        date,
        moods: [moodValue],
        energy: [energyValue]
      });
    }
  });

  const averageMood = totalMood / entries.length;
  const averageEnergy = totalEnergy / entries.length;

  // Generate insights
  if (averageMood >= 7) {
    insights.push("You've been having a great week! Your mood has been consistently positive.");
  } else if (averageMood <= 3) {
    insights.push("It looks like you've been going through a challenging time. Remember to be kind to yourself.");
  } else {
    insights.push("Your mood has been relatively stable this week.");
  }

  if (averageEnergy >= 7) {
    insights.push("Your energy levels have been high - great job taking care of yourself!");
  } else if (averageEnergy <= 3) {
    insights.push("Your energy levels have been low. Consider incorporating more rest or energizing activities.");
  }

  // Find most common mood
  const mostCommonMood = Object.keys(moodCounts).reduce((a, b) => 
    moodCounts[a] > moodCounts[b] ? a : b
  );

  if (mostCommonMood) {
    insights.push(`You've been feeling "${mostCommonMood}" most frequently.`);
  }

  // Find most common tags
  const topTags = Object.keys(tagCounts)
    .sort((a, b) => tagCounts[b] - tagCounts[a])
    .slice(0, 3);

  if (topTags.length > 0) {
    insights.push(`Your most frequent activities were: ${topTags.join(', ')}.`);
  }

  // Generate recommendations
  if (averageMood < 5) {
    recommendations.push("Consider trying a mood-lifting activity like exercise, meditation, or spending time with loved ones.");
  }

  if (averageEnergy < 5) {
    recommendations.push("Focus on improving your sleep hygiene and consider reducing stress where possible.");
  }

  if (entries.filter(e => e.favorite).length === 0) {
    recommendations.push("Try marking entries as favorites to track your most meaningful moments.");
  }

  return {
    period,
    totalEntries: entries.length,
    averageMood: Math.round(averageMood * 10) / 10,
    averageEnergy: Math.round(averageEnergy * 10) / 10,
    moodDistribution: moodCounts,
    topTags,
    dailyTrends: dailyMoods,
    insights,
    recommendations
  };
};

module.exports = {
  generateMoodInsights
};
