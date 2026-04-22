# Pulsara

Pulsara is a mental health journal and mood tracking app. It helps users document their daily thoughts and keep track of their emotional well-being through stats and summaries. The project is split into a React Native frontend and a Node.js backend.

## Features

- **Daily Journaling**: Write notes and pick your mood for the day. It includes daily prompts to help you start writing and tags to categorize entries.
- **Mood Tracking**: View trends over the last 7 or 30 days to see how your mood changes.
- **Insights**: The app summarizes your data to show your most frequent moods and tags.
- **Role Access**: Different interfaces for Patients and Wellness Inspectors.
- **Calendar & Export**: Browse past entries via a calendar or export them to text files.
- **Authentication**: Secure sign-in/sign-up and an onboarding flow for new users.

## Tech Stack

- **Frontend**: Swift, SwiftUI
- **Backend**: Node.js, Express, MongoDB
- **Deployment**: Vercel (Backend)

## Project Structure

- `src/`: Frontend code including screens, components, and services.
- `backend/`: Server-side code with models, routes, and controllers.
- `App.js`: Main entry point for the mobile application.

## How to Run

### 1. Clone the repository
```bash
git clone https://github.com/Gautam-Bharadwaj/Pulsara.git
cd Pulsara
```

### 2. Frontend Setup
```bash
npm install
npx expo start
```

### 3. Backend Setup
```bash
cd backend
npm install
# Create a .env file and add your MONGO_URI
npm start
```

## Contributing
If you want to contribute, feel free to open a pull request or report any issues you find.
